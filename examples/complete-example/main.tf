module "route53" {
  source = "../.."

  # The name of the hosted zone
  name = "mineiros.io"

  # Create Google Suite MX records
  enable_google_mail_mx = true

  # Create a range of G Suite service URLs
  google_suite_services_custom_aliases = {
    mail     = "mail",
    calendar = "cal",
    drive    = "drive",
    groups   = "groups"
  }

  # Create a list of A Records
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

  # Create a list of CNAME Records
  cname_records = [
    {
      name = "development"
      ttl  = 5
      records = [
        "dev.mineiros.io"
      ]
    }
  ]
}
