# ---------------------------------------------------------------------------------------------------------------------
# CREATE A ROUTE53 ZONE WITH SUBDOMAINS AND CNAMES
# This example creates a zone and records for the main domain and a subdomain.
#   - (www.)acme.com
#   - (www.)dev.acme.com
#
# The www. subdomains are implement through CNAMES and point on the A records.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Configure the AWS Provider
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the zone and its records
# ---------------------------------------------------------------------------------------------------------------------

module "route53" {
  source = "../.."

  name = var.zone_name

  records = [
    {
      # We don't explicitly need to set names for records that match the zone
      type    = "A"
      ttl     = var.primary_ttl
      records = var.primary_targets
    },
    {
      type = "CNAME"
      name = "www"
      records = [
        var.zone_name
      ]
    },
    {
      name    = "dev"
      type    = "A"
      ttl     = var.dev_ttl
      records = var.dev_targets
    },
    {
      type = "CNAME"
      name = "www.dev.${var.zone_name}"
      records = [
        "dev.${var.zone_name}"
      ]
    },
  ]
}
