# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region
}

# Default VPC. Terraform does not create this resource, but instead "adopts" it into management.
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

module "private-hosted-zone" {
  source = "../.."

  name = "mineiros.dev"

  vpc_ids = [
    aws_default_vpc.default.id
  ]

  records = [
    {
      type = "A"
      ttl  = 3600
      records = [
        "172.217.16.209"
      ]
    }
  ]
}
