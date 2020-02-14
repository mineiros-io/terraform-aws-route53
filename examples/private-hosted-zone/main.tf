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

locals {
  main_domain = "mineiros.dev"
}

module "private-hosted-zone" {
  source = "../.."

  name = local.main_domain
  vpc_ids = [
    aws_default_vpc.default.id
  ]

  records = [
    {
      type = "A"
      name = local.main_domain
      ttl  = 3600
      records = [
        "172.217.16.209"
      ]
    }
  ]
}
