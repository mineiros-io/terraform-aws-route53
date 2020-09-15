# ---------------------------------------------------------------------------------------------------------------------
# CREATE A ROUTE53 PRIVATE ZONE AND ASSOCIATE A SINGLE A-RECORD
#
# A private hosted zone is a container for records for a domain that you host in one or more Amazon virtual private
# clouds (VPCs). You create a hosted zone for a domain (such as example.com), and then you create records to tell
# Amazon Route 53 how you want traffic to be routed for that domain within and among your VPCs.
#
# # For more information on weighted route policies with Route53, please check the related documentation:
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-creating.html
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Configure the AWS Provider
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

# Default VPC. Terraform does not create this resource, but instead "adopts" it into management.
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the private zone and a-record
# ---------------------------------------------------------------------------------------------------------------------

module "route53" {
  source = "../.."

  name = var.zone_name

  # Private zones require at least one VPC association at all times.
  vpc_ids = [
    aws_default_vpc.default.id
  ]

  records = [
    {
      type    = "A"
      ttl     = var.record_ttl
      records = var.record_records
    }
  ]
}
