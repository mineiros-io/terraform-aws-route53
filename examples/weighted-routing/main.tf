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

  weighted_records = [
    {
      type           = "A"
      weight         = 90
      set_identifier = "prod"
      records = [
        "216.239.32.117"
      ]
    },
    {
      type           = "A"
      weight         = 10
      set_identifier = "preview"
      records = [
        "216.239.32.118"
      ]
    },
  ]

  records = [
    {
      name = "dev"
      type = "CNAME"
      records = [
        "216.239.32.119"
      ]
    }
  ]

}
