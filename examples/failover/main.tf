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
  region = var.aws_region
}

# ---------------------------------------------------------------------------------------------------------------------
# We configure two records with associated healthchecks. Route53 will route the traffic to the secondary record if
# the healthcheck of the primary record reports an unhealthy status.
#
# For more information on DNS failover with Route53, please check the related documentation:
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-failover
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_health_check" "primary" {
  fqdn              = "test.mineiros.io"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "5"
  request_interval  = "30"

  tags = {
    Name = "test-mineiros-io-primary-healthcheck"
  }
}

resource "aws_route53_health_check" "secondary" {
  fqdn              = "test.mineiros.io"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "5"
  request_interval  = "30"

  tags = {
    Name = "test-mineiros-io-secondary-healthcheck"
  }
}

module "mineiros-io" {
  source = "../.."

  name = "test.mineiros.io"

  records = [
    {
      type            = "A"
      set_identifier  = "prod"
      failover        = "PRIMARY"
      health_check_id = aws_route53_health_check.primary.id
      records = [
        "172.217.16.174"
      ]
    },
    {
      type            = "A"
      set_identifier  = "prod"
      failover        = "SECONDARY"
      health_check_id = aws_route53_health_check.secondary.id
      records = [
        "172.217.22.99",
        "172.217.22.100"
      ]
    }
  ]
}
