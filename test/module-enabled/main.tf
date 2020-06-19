# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# UNIT TEST MODULE
# This module exists for the purpose of testing only and should not be
# considered as an example.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "aws" {
  region  = var.aws_region
  version = "~> 2.45"
}

module "test" {
  source = "../.."

  module_enabled = false
}
