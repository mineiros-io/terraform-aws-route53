# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE53 WEIGHTED RECORDS
#
# If defined in var.weighted_records, we prepare and create the weighted records.
# Please see the docs for more information on weighted records with Route53:
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Prepare the records
# ---------------------------------------------------------------------------------------------------------------------

locals {
  weighted_records_expanded = [
    for record in var.weighted_records : merge({
      record_id = join("-", compact([
        lower(record.type),
        try(lower(record.name), ""),
        try(lower(record.set_identifier), "")]
        )
      )

      name            = ""
      ttl             = null
      records         = null
      alias           = null
      allow_overwrite = null
      set_identifier  = null
      weight          = null
      health_check_id = null
    }, record)
  ]

  weighted_records_transposed = {
    for record in local.weighted_records_expanded : record.record_id => record
  }

  weighted_records_by_name = var.enable_module ? {
    for product in setproduct(local.zones, keys(local.weighted_records_transposed)) : "${product[1]}-${product[0]}" => {

      # We need to wrap the reference to aws_route53_zone inside a try to avoid exceptations that might occur when we
      # run terraform destroy without running a successful terraform apply before.
      zone_id = try(aws_route53_zone.zone[product[0]].id, null)

      set_identifier  = local.weighted_records_transposed[product[1]].set_identifier
      weight          = local.weighted_records_transposed[product[1]].weight
      name            = local.weighted_records_transposed[product[1]].name
      type            = local.weighted_records_transposed[product[1]].type
      allow_overwrite = local.weighted_records_transposed[product[1]].allow_overwrite
      health_check_id = try(local.weighted_records_transposed[product[1]].health_check_id, null)

      # TTL conflicts with Alias records. If no alias is set, we should either use the ttl defined with the current
      # record or fall back to the default TTL that is configurable with var.default_ttl
      ttl = local.weighted_records_transposed[product[1]].alias == null ? try(
        local.weighted_records_transposed[product[1]].ttl == null ? var.default_ttl : local.weighted_records_transposed[product[1]].ttl,
        var.default_ttl
      ) : null

      # The DNS protocol has a 255 character limit per string, however, each TXT record can have multiple strings,
      # each 255 characters long. Hence, we split up the passed records for TXT records.
      records = try([for record in local.weighted_records_transposed[product[1]].records :
        local.weighted_records_transposed[product[1]].type == "TXT" && length(regexall("(\\\"\\\")", record)) == 0 ?
        join("\"\"", compact(split("{SPLITHERE}", replace(record, "/(.{255})/", "$1{SPLITHERE}")))) : record
      ], null)

      alias = try(local.weighted_records_transposed[product[1]].alias, {})
    }
  } : {}

  weighted_records_by_zone_id = {
    for record in local.weighted_records_transposed : record.record_id => {
      zone_id         = var.zone_id
      name            = record.name
      type            = record.type
      allow_overwrite = record.allow_overwrite
      ttl             = try(record.ttl, null)
      set_identifier  = record.set_identifier
      weight          = record.weight
      health_check_id = try(record.health_check_id, null)
      records         = try(record.records, null)
      alias           = try(record.alias, {})
    }
  }

  weighted_records = local.skip_zone_creation ? local.weighted_records_by_zone_id : local.weighted_records_by_name
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the records
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_record" "weighted_record" {
  for_each = var.enable_module ? local.weighted_records : {}

  zone_id         = each.value.zone_id
  type            = each.value.type
  allow_overwrite = each.value.allow_overwrite
  name            = each.value.name
  ttl             = each.value.ttl
  records         = each.value.records
  set_identifier  = each.value.set_identifier
  health_check_id = each.value.health_check_id

  dynamic "weighted_routing_policy" {
    for_each = [each.value.weight]

    content {
      weight = weighted_routing_policy.value
    }
  }

  dynamic "alias" {
    for_each = each.value.alias == null ? [] : [each.value.alias]

    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
