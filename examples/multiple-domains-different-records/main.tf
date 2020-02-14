# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region
}

module "zones" {
  source = "../.."

  name = ["mineiros.io", "mineiros.com"]
}

module "mineiros-io" {
  source = "../.."

  zone_id = module.zones["mineiros.io"].zone_id

  records = [
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "10.0.0.1",
        "10.0.0.2",
      ]
    },
    {
      name = ""
      type = "TXT"
      ttl  = 300
      records = [
        "txt1",
        "txt2"
      ]
    },
  ]
}

module "mineiros-com" {
  source = "../.."

  zone_id = module.zones["mineiros.com"].zone_id

  records = [
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "10.0.0.3",
        "10.0.0.4",
      ]
    },
  ]
}
