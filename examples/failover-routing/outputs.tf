output "route53" {
  description = "The outputs of the Route53 module."
  value       = module.route53
}

output "primary_healthcheck" {
  description = "The outputs of the primary healthcheck."
  value       = aws_route53_health_check.primary
}
