resource "aws_route53_zone" "zone" {
  count = var.create ? 1 : 0

  name          = var.name
  force_destroy = var.force_destroy

  tags = merge(
    { Name = var.name },
    var.tags
  )
}

locals {
  a_records = {
    for record in var.a_records : replace(record.name, ".", "-") => {
      name    = record.name
      type    = "A"
      ttl     = try(record.ttl, null)
      records = try(record.records, null)
      alias   = try(record.alias, {})
    }
  }

  cname_records = {
    for record in var.cname_records : replace(record.name, ".", "-") => {
      name    = record.name
      type    = "CNAME"
      ttl     = try(record.ttl, null)
      records = try(record.records, null)
      alias   = try(record.alias, {})
    }
  }

  route53_records = {
    for record in var.records : replace(record.name, ".", "-") => {
      name    = record.name
      type    = record.type
      ttl     = try(record.ttl, null)
      records = try(record.records, null)
      alias   = try(record.alias, {})
    }
  }
}

# Create A records
resource "aws_route53_record" "a_record" {
  for_each = var.create ? local.a_records : {}

  zone_id = aws_route53_zone.zone[0].id
  type    = "A"
  name    = each.value.name
  ttl     = each.value.ttl
  records = each.value.records

  dynamic "alias" {
    # toDo: we could add a condition here that if ttl and records are set alias should be ignored?
    for_each = each.value.alias

    content {
      name                   = each.value.alias.name
      zone_id                = each.value.alias.zone_id
      evaluate_target_health = each.value.alias.evaluate_target_health
    }
  }
}

# Create CNAME records
resource "aws_route53_record" "cname_record" {
  for_each = var.create ? local.cname_records : {}

  zone_id = aws_route53_zone.zone[0].id
  type    = "CNAME"
  name    = each.value.name
  ttl     = each.value.ttl
  records = each.value.records

  dynamic "alias" {
    for_each = each.value.alias

    content {
      name                   = each.value.alias.name
      zone_id                = each.value.alias.zone_id
      evaluate_target_health = each.value.alias.evaluate_target_health
    }
  }
}

resource "aws_route53_record" "record" {
  for_each = var.create ? local.route53_records : {}

  zone_id = aws_route53_zone.zone[0].id
  type    = each.value.type
  name    = each.value.name
  ttl     = each.value.ttl
  records = each.value.records

  dynamic "alias" {
    for_each = each.value.alias

    content {
      name                   = each.value.alias.name
      zone_id                = each.value.alias.zone_id
      evaluate_target_health = each.value.alias.evaluate_target_health
    }
  }
}
