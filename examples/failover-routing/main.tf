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
  fqdn              = var.zone_name
  port              = var.health_check_port
  type              = var.health_check_protocol
  resource_path     = var.health_check_resource_path
  failure_threshold = var.health_check_failure_threshold
  request_interval  = var.health_check_request_interval

  tags = {
    Name = "${replace(var.zone_name, ".", "-")}-primary-healthcheck"
  }
}

module "route53" {
  source = "../.."

  name                         = var.zone_name
  skip_delegation_set_creation = var.skip_delegation_set_creation

  records = [
    {
      type           = "A"
      set_identifier = "prod"
      failover       = "PRIMARY"
      # Non-alias primary records must have an associated health check
      health_check_id = aws_route53_health_check.primary.id
      records         = var.primary_record_records
    },
    {
      type           = "A"
      set_identifier = "prod"
      failover       = "SECONDARY"
      records        = var.secondary_record_records
    }
  ]
}
