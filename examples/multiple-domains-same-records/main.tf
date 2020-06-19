# ---------------------------------------------------------------------------------------------------------------------
# CREATE TWO ZONES WITH SAME RECORDS
#
# We create two zones and attach the same set of records to both. The zones will share the same delegation set.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Configure the AWS Provider
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.45"
}

module "zones" {
  source  = "mineiros-io/route53/aws"
  version = "0.2.2"

  # Create two zones
  name = [
    "mineiros.io",
    "mineiros.com"
  ]

  # Attach the same records to both created zones
  records = [
    {
      type = "A"
      ttl  = 3600
      records = [
        "203.0.113.100",
        "203.0.113.101",
      ]
    },
    {
      type = "TXT"
      ttl  = 300
      records = [
        "Lorem ipsum"
      ]
    },
    {
      name = "testing"
      type = "A"
      ttl  = 3600
      records = [
        "203.0.113.200",
      ]
    },
  ]
}
