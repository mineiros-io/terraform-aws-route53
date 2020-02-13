# Default VPC. Terraform does not create this resource, but instead "adopts" it into management.
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_elb" "main" {
  name               = "example-elb"
  availability_zones = ["us-east-1c"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

module "route53" {
  source = "../.."

  name = "mineiros.io"

  a_records = [
    {
      name = "mineiros.io"
      alias = {
        name                   = aws_elb.main.dns_name
        zone_id                = aws_elb.main.zone_id
        evaluate_target_health = true
      }
    }
  ]

  cname_records = [
    {
      name = "www"
      ttl  = 3600
      records = [
        "mineiros.io"
      ]
    }
  ]

}