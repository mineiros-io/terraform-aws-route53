# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE53 ZONES AND RECORDS
#
# This module creates one or multiple Route53 zones with associated records and delegation set.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Prepare locals to keep the code cleaner
# ---------------------------------------------------------------------------------------------------------------------

locals {
  zones                        = var.name == null ? [] : try(tolist(var.name), [tostring(var.name)], [])
  skip_zone_creation           = length(local.zones) == 0
  run_in_vpc                   = length(var.vpc_ids) > 0
  skip_delegation_set_creation = ! var.enable_module || local.skip_zone_creation || local.run_in_vpc ? true : var.skip_delegation_set_creation

  delegation_set_id = var.delegation_set_id != null ? var.delegation_set_id : try(
    aws_route53_delegation_set.delegation_set[0].id, null
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Create a delegation set to share the same nameservers among multiple zones
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_delegation_set" "delegation_set" {
  count = local.skip_delegation_set_creation ? 0 : 1

  reference_name = var.reference_name
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the zones
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_zone" "zone" {
  for_each = var.enable_module ? toset(local.zones) : []

  name              = each.value
  comment           = var.comment
  force_destroy     = var.force_destroy
  delegation_set_id = local.delegation_set_id

  dynamic "vpc" {
    for_each = { for id in var.vpc_ids : id => id }

    content {
      vpc_id = vpc.value
    }
  }

  tags = merge(
    { Name = each.value },
    var.tags
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Prepare the records
# ---------------------------------------------------------------------------------------------------------------------

locals {
  records_expanded = {
    for i, record in var.records : join("-", compact([
      lower(record.type),
      try(lower(record.set_identifier), ""),
      try(lower(record.failover), ""),
      try(lower(record.name), ""),
    ])) => i
  }

  records_by_name = {
    for product in setproduct(local.zones, keys(local.records_expanded)) : "${product[1]}-${product[0]}" => {
      zone_id = try(aws_route53_zone.zone[product[0]].id, null)
      idx     = local.records_expanded[product[1]]
    }
  }

  records_by_zone_id = {
    for id, idx in local.records_expanded : id => {
      zone_id = var.zone_id
      idx     = idx
    }
  }

  records = local.skip_zone_creation ? local.records_by_zone_id : local.records_by_name
}

# ---------------------------------------------------------------------------------------------------------------------
# Attach the records to our created zone(s)
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_record" "record" {
  for_each = var.enable_module ? local.records : {}

  zone_id         = each.value.zone_id
  type            = var.records[each.value.idx].type
  name            = try(var.records[each.value.idx].name, "")
  allow_overwrite = try(var.records[each.value.idx].allow_overwrite, var.allow_overwrite)
  health_check_id = try(var.records[each.value.idx].health_check_id, null)
  set_identifier  = try(var.records[each.value.idx].set_identifier, null)

  # only set default TTL when not set and not alias record
  ttl = ! can(var.records[each.value.idx].ttl) && ! can(var.records[each.value.idx].alias) ? var.default_ttl : try(var.records[each.value.idx].ttl, null)

  # split TXT records at 255 chars to support >255 char records
  records = can(var.records[each.value.idx].records) ? [for r in var.records[each.value.idx].records :
    var.records[each.value.idx].type == "TXT" && length(regexall("(\\\"\\\")", r)) == 0 ?
    join("\"\"", compact(split("{SPLITHERE}", replace(r, "/(.{255})/", "$1{SPLITHERE}")))) : r
  ] : null

  dynamic "weighted_routing_policy" {
    for_each = try([var.records[each.value.idx].weight], [])

    content {
      weight = weighted_routing_policy.value
    }
  }

  dynamic "failover_routing_policy" {
    for_each = try([var.records[each.value.idx].failover], [])

    content {
      type = failover_routing_policy.value
    }
  }

  dynamic "alias" {
    for_each = try([var.records[each.value.idx].alias], [])

    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
