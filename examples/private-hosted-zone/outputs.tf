output "default_vpc" {
  description = "The outputs of the default VPC."
  value       = aws_default_vpc.default
}

output "route53" {
  description = "The outputs of the Route53 module."
  value       = module.route53
}
