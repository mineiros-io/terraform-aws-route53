output "route53" {
  description = "All outputs of the created zone and its records."
  value       = module.route53
}

output "zone_name" {
  description = "The name of the created zone."
  value       = module.route53.zone[var.zone_name].name
}

output "dev_targets" {
  description = "The targets for the dev subdomain a record."
  value       = module.route53.records["a-dev-${var.zone_name}"].records
}
