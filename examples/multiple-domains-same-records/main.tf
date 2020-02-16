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
  records = [
    {
      type = "A"
      name = "testing"
      ttl  = 3600
      records = [
        "172.217.16.209"
      ]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "172.217.16.206",
        "172.217.18.163"
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
