# ---------------------------------------------------------------------------------------------------------------------
# ROUTE53 ZONE WITH RECORDS THAT HAVE A FAILOVER ROUTING POLICY ATTACHED
#
# Failover routing lets you route traffic to a resource when the resource is healthy or to a different resource when the
# first resource is unhealthy. The primary and secondary records can route traffic to anything from an Amazon S3 bucket
# that is configured as a website to a complex tree of records.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Configure the AWS Provider
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# We configure two records with associated healthchecks. Route53 will route the traffic to the secondary record if
# the healthcheck of the primary record reports an unhealthy status.
#
# For more information on DNS failover with Route53, please check the related documentation:
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-failover
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_health_check" "primary" {
  fqdn              = "mineiros.io"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 5
  request_interval  = 30

  tags = {
    Name = "mineiros-io-primary-healthcheck"
  }
}

module "route53" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.5.0"

  name                         = "mineiros.io"
  skip_delegation_set_creation = true

  records = [
    {
      type           = "A"
      set_identifier = "primary"
      failover       = "PRIMARY"
      # Non-alias primary records must have an associated health check
      health_check_id = aws_route53_health_check.primary.id
      records = [
        "203.0.113.200"
      ]
    },
    {
      type            = "A"
      set_identifier  = "failover"
      failover        = "SECONDARY"
      health_check_id = null
      records = [
        "203.0.113.201",
        "203.0.113.202"
      ]
    }
  ]
}
