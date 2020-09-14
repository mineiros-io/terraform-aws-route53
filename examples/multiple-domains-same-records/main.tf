# ---------------------------------------------------------------------------------------------------------------------
# CREATE TWO ROUTE53 ZONES WITH SAME RECORDS
#
# We create two zones and attach the same set of records to both. The zones will share the same delegation set.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

module "zones" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.3.0"

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
        "203.0.113.200",
        "203.0.113.201"
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
        "203.0.113.202"
      ]
    },
  ]
}
