resource "aws_route53_zone" "zone" {
  count = var.create ? 1 : 0

  name          = var.name
  force_destroy = var.force_destroy

  tags = var.tags
}

locals {
  route53_records = {
    for record in var.records : replace(record.name, ".", "-") => {
      name   = record.name
      type   = record.type
      ttl    = try(record.ttl, "300")
      weight = try(record.weight, 0)
    }
  }
}

resource "aws_route53_record" "record" {
  for_each = var.create ? local.route53_records : {}

  zone_id = aws_route53_zone.zone[0].id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl

  weighted_routing_policy {
    weight = each.value.weight
  }
}

