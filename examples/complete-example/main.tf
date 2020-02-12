module "route53" {
  source = "../.."

  name = "mineiros.test"

  records = [
    {
      name                             = "www.mineiros.test"
      type                             = "A"
      ttl                              = "300"
      weight                           = 90
      set_identifier                   = ""
      health_check_id                  = ""
      alias                            = ""
      failover_routing_policy          = ""
      geolocation_routing_policy       = ""
      latency_routing_policy           = ""
      weighted_routing_policy          = ""
      multivalue_answer_routing_policy = ""
      allow_overwrite                  = ""
      records                          = []
    }
  ]
}
