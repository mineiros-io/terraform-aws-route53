# ---------------------------------------------------------------------------------------------------------------------
# CREATE TWO ROUTE53 ZONES THAT SHARE THE SAME DELEGATION SET ( A GROUP OF FOUR NAME SERVERS )
#
# A set of four authoritative name servers that you can use with more than one hosted zone. By default, Route 53 assigns
# a random selection of name servers to each new hosted zone. To make it easier to migrate DNS service to Route 53 for a
# large number of domains, you can create a reusable delegation set and then associate the reusable delegation set with
# new hosted zones.
#
# For more information on delegation sets with Route53, please check the related documentation:
# https://docs.aws.amazon.com/cli/latest/reference/route53/create-reusable-delegation-set.html
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Configure the AWS Provider
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region  = var.aws_region
  version = "~> 2.45"
}

# ---------------------------------------------------------------------------------------------------------------------
# If we don't set the delegation_set_id or set skip_delegation_set_creation = true, each created zone will automatically
# create an associated delegation set.
# ---------------------------------------------------------------------------------------------------------------------

module "route53-zone-with-delegation-set" {
  source = "../.."

  name = var.main_zone_name
}

# ---------------------------------------------------------------------------------------------------------------------
# We create a second zone that will use the delegation set we created in our first zone. Since both zones are using
# the same delegation set, they will share the same Nameservers.
# ---------------------------------------------------------------------------------------------------------------------

module "route53-zone" {
  source = "../.."

  name              = var.secondary_zone_name
  delegation_set_id = module.route53-zone-with-delegation-set.delegation_set.id
}
