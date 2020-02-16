locals {
  skip_zone_creation = length(local.zones) == 0
  zones              = var.name == null ? [] : try(tolist(var.name), [tostring(var.name)], [])
  delegation_set_id  = var.delegation_set_id != "" ? var.delegation_set_id : try(aws_route53_delegation_set.delegation_set[0].id, null)

  run_in_vpc = length(var.vpc_ids) > 0

  skip_delegation_set_creation = local.skip_zone_creation || local.run_in_vpc ? true : var.skip_delegation_set_creation
}

resource "aws_route53_delegation_set" "delegation_set" {
  count = local.skip_delegation_set_creation ? 0 : 1

  reference_name = try(coalesce(var.reference_name, local.zones[0]), null)
}

resource "aws_route53_zone" "zone" {
  for_each = toset(local.zones)

  name              = each.value
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

locals {
  records_expanded = [
    for record in var.records : merge({
      record_id = join("-", compact([lower(record.type), lower(record.name)]))
      ttl       = null
      records   = null
      alias     = null
    }, record)
  ]

  records_transposed = {
    for record in local.records_expanded : record.record_id => record
  }

  records_by_name = {
    for product in setproduct(local.zones, keys(local.records_transposed)) :
    "${product[1]}-${product[0]}" => {
      zone_id = aws_route53_zone.zone[product[0]].id
      name    = local.records_transposed[product[1]].name
      type    = local.records_transposed[product[1]].type
      ttl     = try(local.records_transposed[product[1]].ttl, null)
      records = try(local.records_transposed[product[1]].records, null)
      alias   = try(local.records_transposed[product[1]].alias, {})
    }
  }

  records_by_zone_id = {
    for record in local.records_transposed : record.record_id => {
      zone_id = var.zone_id
      name    = record.name
      type    = record.type
      ttl     = try(record.ttl, null)
      records = try(record.records, null)
      alias   = try(record.alias, {})
    }
  }

  records = local.skip_zone_creation ? local.records_by_zone_id : local.records_by_name
}

resource "aws_route53_record" "record" {
  for_each = local.records

  zone_id = each.value.zone_id
  type    = each.value.type
  name    = each.value.name
  ttl     = each.value.ttl
  records = each.value.records

  dynamic "alias" {
    for_each = each.value.alias == null ? [] : [each.value.alias]

    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
