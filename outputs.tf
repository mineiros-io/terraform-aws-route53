output "zone" {
  description = "The created Hosted Zone(s)."
  value       = aws_route53_zone.zone
}

output "records" {
  description = "A list of all created records."
  value       = aws_route53_record.record
}

output "weighted_records" {
  description = "A list of all created weighted records."
  value       = aws_route53_record.weighted_record
}

output "failover_records" {
  description = "A list of all created failover records."
  value       = aws_route53_record.failover_record
}

output "delegation_set" {
  description = "The outputs of the created delegation set."
  value       = try(aws_route53_delegation_set.delegation_set[0], null)
}
