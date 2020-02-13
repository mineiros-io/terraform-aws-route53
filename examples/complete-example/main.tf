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

  a_records = [
    {
      name = "mineiros.io"
      ttl  = 300
      records = [
        "172.217.16.206",
        "172.217.18.163"
      ]
    },
    {
      name = "dev.mineiros.io"
      ttl  = 300
      records = [
        "172.217.18.99",
      ]
    }
  ]

  cname_records = [
    {
      name = "development.mineiros.io"
      ttl  = 5
      records = [
        "dev.mineiros.io"
      ]
    }
  ]

  records = [
    {
      type = "A"
      name = "testing.mineiros.io"
      ttl  = 3600
      #      allow_overwrite = true
      #      health_check_id = ""
      records = [
        "172.217.16.209"
      ]
    }
  ]
}
