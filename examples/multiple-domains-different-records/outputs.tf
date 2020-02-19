output "zones" {
  description = "All created zones."
  value       = module.zones
}

output "zone_a_records" {
  description = "All records created in zone a."
  value       = module.zone_a_records
}

output "zone_b_records" {
  description = "All records created in zone b."
  value       = module.zone_b_records
}
