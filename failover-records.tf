# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE53 FAILOVER RECORDS
#
# If defined in var.weighted_records, we prepare and create the failover records.
# Please see the docs for more information on failover records with Route53:
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-failover
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Prepare the records
# ---------------------------------------------------------------------------------------------------------------------

locals {
  failover_records_expanded = [
    for record in var.failover_records : merge({
      record_id = join("-", compact([
        lower(record.type),
        try(lower(record.name), ""),
        try(lower(record.set_identifier), ""),
        try(lower(record.failover), "")]
        )
      )

      name            = ""
      ttl             = null
      records         = null
      alias           = null
      allow_overwrite = null
      set_identifier  = null
      failover        = null
      health_check_id = null
    }, record)
  ]

  failover_records_transposed = {
    for record in local.failover_records_expanded : record.record_id => record
  }

  failover_records_by_name = var.enable_module ? {
    for product in setproduct(local.zones, keys(local.failover_records_transposed)) : "${product[1]}-${product[0]}" => {

      zone_id         = try(aws_route53_zone.zone[product[0]].id, null)
      name            = local.failover_records_transposed[product[1]].name
      type            = local.failover_records_transposed[product[1]].type
      allow_overwrite = local.failover_records_transposed[product[1]].allow_overwrite

      # Healthchecks and identifier are mandatory for failover records
      health_check_id = local.failover_records_transposed[product[1]].health_check_id

      set_identifier = local.failover_records_transposed[product[1]].set_identifier
      failover       = local.failover_records_transposed[product[1]].failover
      alias          = try(local.failover_records_transposed[product[1]].alias, {})

      ttl = local.failover_records_transposed[product[1]].alias == null ? try(
        local.failover_records_transposed[product[1]].ttl == null ? var.default_ttl : local.failover_records_transposed[product[1]].ttl,
        var.default_ttl
      ) : null

      records = try(local.failover_records_transposed[product[1]].records, null)
    }
  } : {}

  failover_records_by_zone_id = {
    for record in local.failover_records_transposed : record.record_id => {
      zone_id         = var.zone_id
      name            = record.name
      type            = record.type
      allow_overwrite = record.allow_overwrite

      # Healthchecks and identifier are mandatory for failover records
      health_check_id = record.health_check_id

      set_identifier = record.set_identifier
      failover       = record.failover
      alias          = try(record.alias, {})

      ttl = record.alias == null ? try(record.ttl == null ? var.default_ttl : record.ttl, var.default_ttl) : null

      records = try([for r in record.records :
        record.type == "TXT" && length(regexall("(\\\"\\\")", r)) == 0 ?
        join("\"\"", compact(split("{SPLITHERE}", replace(r, "/(.{255})/", "$1{SPLITHERE}")))) : r
      ], null)
    }
  }

  failover_records = local.skip_zone_creation ? local.failover_records_by_zone_id : local.failover_records_by_name
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the records
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_record" "failover_record" {
  for_each = var.enable_module ? local.failover_records : {}

  zone_id         = each.value.zone_id
  type            = each.value.type
  allow_overwrite = each.value.allow_overwrite
  name            = each.value.name
  ttl             = each.value.ttl
  records         = each.value.records
  set_identifier  = each.value.set_identifier
  health_check_id = each.value.health_check_id

  dynamic "failover_routing_policy" {
    for_each = [each.value.failover]

    content {
      type = failover_routing_policy.value
    }
  }

  dynamic "alias" {
    for_each = each.value.alias == null ? [] : [
    each.value.alias]

    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
