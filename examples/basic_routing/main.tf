# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

module "route53" {
  source = "../.."

  name                  = "mineiros.io"
  create_google_mail_mx = true
  create_google_spf     = true

  # Create a range of G Suite service URLs
  google_suite_services_custom_aliases = {
    mail     = "mail",
    calendar = "calendar",
    drive    = "drive",
    groups   = "groups"
  }

  google_mail_dkim = {
    "google._domainkey" = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoeaZAFNfAvwiMkuIHimJVODdtPX+9d7uVhFrML2S8m0GNd0c9w8Os5nQBeQaBmm1h7S/yxYrc5lcV5eaF1TgBmg9fYrwKXG8u1+gotmhFHhWl/GebYiUa/PchLAG+rrSav7lDlB3uTcbMGZUPQ3uuQOEwqi7SRsAFilAYFIkK+N6Crpis9LABFVAkrWsEbxOpVArxAdRpe6UuYAnS/Ge1uGOKu3L1kK5AGVN2HIkQPEllAQ0KY2yiPGfQXw8SA5ibZ0FjKlnw4amocZyBSLBlpHo9/qzLAy9JoByTOoZXdijikPY7zioSGIfOaY0RqSIpR338VXhHS76QMrDG5fLwQIDAQAB"
  }

  records = [
    {
      # We don't explicitly need to set a name if the record matches the zone
      # name = "mineiros.io"
      type = "A"
      ttl  = 300
      records = [
        "172.217.16.206",
        "172.217.18.163"
      ]
    },
    {
      # This record doesn't have a explicitly TTL set. Therefore it will assume the default TTL that is configurable
      # through var.default_ttl.
      name = "testing.mineiros.io"
      type = "A"
      records = [
        "172.217.16.209"
      ]
    },
    {
      name = "dev.mineiros.io"
      type = "A"
      ttl  = 300
      records = [
        "172.217.18.99",
      ]
    },
    {
      name = "development.mineiros.io"
      type = "CNAME"
      ttl  = 5
      records = [
        "dev.mineiros.io"
      ]
    }
  ]
}