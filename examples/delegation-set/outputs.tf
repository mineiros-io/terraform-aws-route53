output "zone-with-delegated-set" {
  description = "The outputs of the primary zone with which we create the delegated set."
  value       = module.route53-zone-with-delegation-set
}

output "secondary-zone" {
  description = "The outputs of the secondary zone."
  value       = module.route53-zone
}
