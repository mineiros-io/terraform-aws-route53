# ---------------------------------------------------------------------------------------------------------------------
# CREATE A ROUTE53 ZONE AND ASSOCIATE TWO WEIGHTES RECORDS
#
# Weighted routing lets you associate multiple resources with a single domain name (example.com) or subdomain name
# (acme.example.com) and choose how much traffic is routed to each resource. This can be useful for a variety of
# purposes, including load balancing and testing new versions of software.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Configure the AWS Provider
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

# ---------------------------------------------------------------------------------------------------------------------
# We configure two A records for our domain mineiros.io. The records are differentiated by using set_identifier.
# The first record points to our production system to which we want to route 90% of our traffic. The second record
# points to our preview system and we only want to route 10% of our traffic to that system.
#
# For more information on weighted route policies with Route53, please check the related documentation:
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted
# ---------------------------------------------------------------------------------------------------------------------

module "route53" {
  source = "../.."

  name                         = var.zone_name
  skip_delegation_set_creation = var.skip_delegation_set_creation

  # We send 90% of our traffic to the prod system and 10% of our traffic to the preview system
  weighted_records = [
    {
      type           = "A"
      set_identifier = "prod"
      weight         = 90
      records        = var.prod_targets
    },
    {
      type           = "A"
      set_identifier = "preview"
      weight         = 10
      records        = var.preview_targets
    }
  ]

  records = [
    {
      type    = "A"
      name    = "dev"
      records = var.dev_targets
    }
  ]

}
