# ---------------------------------------------------------------------------------------------------------------------
# CREATE TWO ZONES WITH SAME RECORDS
#
# We create two zones and attach the same set of records to both. The zones will share the same delegation set.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region  = var.aws_region
  version = "~> 2.45"
}

module "zones" {
  source = "../.."

  # Create two zones
  name = [
    var.zone_a,
    var.zone_b
  ]

  # Attach the same records to both created zones
  records = [
    {
      type    = "A"
      ttl     = var.primary_ttl
      records = var.primary_targets
    },
    {
      type    = "TXT"
      ttl     = 300
      records = var.primary_txt_targets
    },
    {
      name    = "testing"
      type    = "A"
      ttl     = var.testing_ttl
      records = var.testing_targets
    },
  ]
}
