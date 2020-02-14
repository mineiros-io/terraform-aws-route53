output "zone_id" {
  description = "The Hosted Zone ID. This can be referenced by zone records."
  value       = try(aws_route53_zone.zone[var.name].zone_id, null)
}

output "name_servers" {
  description = "A list of name servers in associated (or default) delegation set."
  value       = try(aws_route53_zone.zone[var.name].name_servers, null)
}

output "records" {
  description = "A list of all created records."
  value       = aws_route53_record.record
}

output "delegation_set_id" {
  description = "The ID of the created delegation set."
  value       = try(aws_route53_delegation_set.delegation_set[0].id, "")
}

output "delegation_set_reference_name" {
  description = "The reference name used in Caller Reference (helpful for identifying single delegation set amongst others)."
  value       = try(aws_route53_delegation_set.delegation_set[0].reference_name, "")
}
