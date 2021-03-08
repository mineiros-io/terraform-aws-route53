# ---------------------------------------------------------------------------------------------------------------------
# CREATE TWO ROUTE53 ZONES WITH DIFFERENT RECORDS
#
# We create two zones and different records using the convenient name = [] shortcut.
# All created zones will share the same delegation set.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Configure the AWS Provider
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# Create multiple zones with a single module
module "zones" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.4.0"

  name = [
    "mineiros.io",
    "mineiros.com"
  ]
}

# Create the records for zone a
module "zone_a_records" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.4.0"

  # Wrap the reference to the zone inside a try statement to prevent ugly exceptions if we run terraform destroy
  # without running a successful terraform apply before.
  zone_id = try(module.zones.zone["mineiros.io"].zone_id, null)

  records = [
    {
      type = "TXT"
      ttl  = 300
      records = [
        "Lorem ipsum"
      ]
    }
  ]
}

# Create the records for zone b
module "zone_b_records" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.4.0"

  zone_id = try(module.zones.zone["mineiros.com"].zone_id, null)

  records = [
    {
      type = "TXT"
      ttl  = 600
      records = [
        "Lorem ipsum",
        "Lorem ipsum dolor sit amet"
      ]
    }
  ]
}
