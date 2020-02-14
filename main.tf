locals {
  zones = map(var.name, var.name)
}

resource "aws_route53_zone" "zone" {
  for_each = var.create ? local.zones : {}

  name              = var.name
  force_destroy     = var.force_destroy
  delegation_set_id = length(var.vpc_ids) == 0 && length(var.delegation_set_id) > 0 ? var.delegation_set_id : try(aws_route53_delegation_set.delegation_set[0].id, null)

  dynamic "vpc" {
    for_each = { for id in var.vpc_ids : id => id }

    content {
      vpc_id = vpc.value
    }
  }

  tags = merge(
    { Name = var.name },
    var.tags
  )
}

resource "aws_route53_delegation_set" "delegation_set" {
  count = var.create && var.create_delegation_set ? 1 : 0

  reference_name = length(var.delegation_set_reference_name) > 0 ? var.delegation_set_reference_name : var.name
}

locals {
  records = {
    for record in var.records : record.name => {
      name    = record.name
      type    = record.type
      ttl     = try(record.ttl, null)
      records = try(record.records, null)
      alias   = try(record.alias, {})
    }
  }
}

resource "aws_route53_record" "record" {
  for_each = var.create ? local.records : {}

  zone_id = aws_route53_zone.zone[var.name].id
  type    = each.value.type
  name    = each.value.name
  ttl     = each.value.ttl
  records = each.value.records

  dynamic "alias" {
    for_each = each.value.alias

    content {
      name                   = alias.value.alias.name
      zone_id                = alias.value.alias.zone_id
      evaluate_target_health = alias.value.alias.evaluate_target_health
    }
  }
}
