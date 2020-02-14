output "default_vpc" {
  value = aws_default_vpc.default
}

output "private_hosted_zone" {
  value = module.private-hosted-zone
}
