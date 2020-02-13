output "zone_id" {
  description = "The Hosted Zone ID. This can be referenced by zone records."
  value       = try(aws_route53_zone.zone[0].zone_id, null)
}

output "name_servers" {
  description = "A list of name servers in associated (or default) delegation set"
  value       = try(aws_route53_zone.zone[0].name_servers, null)
}

output "records" {
  value = aws_route53_record.record
}

output "delegation_set" {
  value = try(aws_route53_delegation_set.delegation_set, null)
}
