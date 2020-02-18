# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

module "mineiros-io" {
  source = "../.."

  name = "mineiros.io"
}

module "mineiros-com" {
  source = "../.."

  name              = "mineiros.com"
  delegation_set_id = module.mineiros-io.delegation_set.id
}

module "mineiros-de" {
  source = "../.."

  name              = "mineiros.de"
  delegation_set_id = module.mineiros-io.delegation_set.id
}
