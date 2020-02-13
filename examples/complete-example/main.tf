module "route53" {
  source = "../.."

  name                  = "mineiros.io"
  enable_google_mail_mx = true

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
      name = "www.mineiros.io"
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
      name = "development"
      ttl  = 5
      records = [
        "dev.mineiros.io"
      ]
    }
  ]

  //  records = [
  //    {
  //      name                             = "www.mineiros.test"
  //      type                             = "A"
  //      ttl                              = "300"
  //      weight                           = 90
  //      set_identifier                   = ""
  //      health_check_id                  = ""
  //      alias                            = ""
  //      failover_routing_policy          = ""
  //      geolocation_routing_policy       = ""
  //      latency_routing_policy           = ""
  //      weighted_routing_policy          = ""
  //      multivalue_answer_routing_policy = ""
  //      allow_overwrite                  = ""
  //      records                          = []
  //    }
  //  ]
}
