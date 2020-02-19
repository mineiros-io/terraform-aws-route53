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
  weighted_records_expanded = {
    for record in var.weighted_records : join("-", compact([
      lower(record.type),
      try(lower(record.name), ""),
      try(lower(record.set_identifier), "")])
      ) => merge({

        name            = ""
        ttl             = var.default_ttl
        records         = []
        alias           = {}
        allow_overwrite = false
        health_check_id = null
    }, record)
  }


  weighted_records_by_name = var.enable_module ? {
    for product in setproduct(local.zones, keys(local.weighted_records_expanded)) : "${product[1]}-${product[0]}" => {

      # We need to wrap the reference to aws_route53_zone inside a try to avoid exceptations that might occur when we
      # run terraform destroy without running a successful terraform apply before.
      zone_id         = try(aws_route53_zone.zone[product[0]].id, null)
      name            = local.weighted_records_expanded[product[1]].name
      type            = local.weighted_records_expanded[product[1]].type
      allow_overwrite = local.weighted_records_expanded[product[1]].allow_overwrite
      health_check_id = local.weighted_records_expanded[product[1]].health_check_id
      set_identifier  = local.weighted_records_expanded[product[1]].set_identifier
      weight          = local.weighted_records_expanded[product[1]].weight
      alias           = local.weighted_records_expanded[product[1]].alias

      # TTL conflicts with Alias records. If no alias is set, we should either use the ttl defined with the current
      # record or fall back to the default TTL that is configurable with var.default_ttl
      ttl = local.weighted_records_expanded[product[1]].alias == {} ? local.weighted_records_expanded[product[1]].ttl : null

      # The DNS protocol has a 255 character limit per string. However, each TXT record can contain multiple strings,
      # each with a length of 255 characters. Hence, if a TXT record contains a string that is longer than 255
      # characters, we split it up into multiple substrings.
      records = length(local.weighted_records_expanded[product[1]].records) > 0 ? [
        for record in local.weighted_records_expanded[product[1]].records :
        local.weighted_records_expanded[product[1]].type == "TXT" && length(regexall("(\\\"\\\")", record)) == 0 ?
        join("\"\"", compact(split("{SPLITHERE}", replace(record, "/(.{255})/", "$1{SPLITHERE}")))) : record
      ] : null
    }
  } : {}

  weighted_records_by_zone_id = {
    for id, record in local.weighted_records_expanded : id => {
      zone_id         = var.zone_id
      name            = record.name
      type            = record.type
      allow_overwrite = record.allow_overwrite
      health_check_id = record.health_check_id
      set_identifier  = record.set_identifier
      weight          = record.weight
      alias           = record.alias

      # TTL conflicts with Alias records. If no alias is set, we should either use the t
      # record or fall back to the default TTL that is configurable with var.default_ttl
      ttl = record.alias == {} ? record.ttl : null

      # The DNS protocol has a 255 character limit per string. However, each TXT record can contain multiple strings,
      # each with a length of 255 characters. Hence, if a TXT record contains a string that is longer than 255
      # characters, we split it up into multiple substrings.
      records = length(record.records) > 0 ? [for r in record.records :
        record.type == "TXT" && length(regexall("(\\\"\\\")", r)) == 0 ?
        join("\"\"", compact(split("{SPLITHERE}", replace(r, "/(.{255})/", "$1{SPLITHERE}")))) : r
      ] : null
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
    for_each = length(each.value.alias) > 0 ? [each.value.alias] : []

    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
