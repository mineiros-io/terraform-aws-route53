output "zone" {
  description = "The Hosted Zone."
  value       = aws_route53_zone.zone
}

output "records" {
  description = "A list of all created records."
  value       = merge(aws_route53_record.record, aws_route53_record.weighted_record, aws_route53_record.failover_record)
}

output "delegation_set" {
  description = "The ID of the created delegation set."
  value       = try(aws_route53_delegation_set.delegation_set[0], null)
}
