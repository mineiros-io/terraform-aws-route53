# ---------------------------------------------------------------------------------------------------------------------
# CREATE TWO ZONES WITH DIFFERENT RECORDS
#
# We create two zones and different records using the convinient name = [] shortcut.
# All created zones will share the same delegation set.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Configure the AWS Provider
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region  = var.aws_region
  version = "~> 2.45"
}

# Create multiple zones with a single module
module "zones" {
  source = "../.."

  name = [
    var.zone_a,
    var.zone_b
  ]
}

# Create the records for zone a
module "zone_a_records" {
  source = "../.."

  # Wrap the reference to the zone inside a try statement to prevent ugly exceptions if we run terraform destroy
  # without running a successful terraform apply before.
  zone_id = try(module.zones.zone[var.zone_a].zone_id, null)

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
  source = "../.."

  zone_id = try(module.zones.zone[var.zone_b].zone_id, null)

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
