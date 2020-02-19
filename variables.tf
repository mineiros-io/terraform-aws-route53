# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables.
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the hosted zone. To create multiple zones at once, pass a list of names [\"zone1\", \"zone2\"]."
  type        = any

  # Examples:
  #
  # Single:   name = "example.com"
  # Multiple: name = ["example.com", "example.io"]
  default = null
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "comment" {
  description = "A comment for the hosted zone."
  type        = string
  default     = "Managed by Terraform"
}

variable "default_ttl" {
  description = "The default TTL ( Time to Live ) in seconds that will be used for all records that support the ttl parameter. Will be overwritten by the records ttl parameter if set."
  type        = number
  default     = 3600
}

variable "delegation_set_id" {
  description = "The ID of the reusable delegation set whose NS records you want to assign to the hosted zone."
  type        = string
  default     = null
}

variable "enable_module" {
  description = "Whether to enable the module and to create the Route53 Zone and it's associated resources."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Whether to force destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
  type        = bool
  default     = false
}

variable "records" {
  description = "A list of records to create in the Hosted Zone."
  type        = any

  # We unfortunately cannot use rich value types for now, we still need to wait for optional arguments to be released.
  #  type      = list(object({
  #    name    = string
  #    ttl     = number
  #    records = list(string)
  #  }))

  # Example:
  #
  # records = [
  #   {
  #     name = "example.com"
  #     type = "A"
  #     ttl  = 300
  #     records = [
  #       "172.217.16.206",
  #       "172.217.18.163"
  #     ]
  #   },
  #   {
  #     name = "www"
  #     type = "CNAME"
  #     ttl  = 3600
  #     records = [
  #       "example.com"
  #     ]
  #   },
  #   {
  #     name = "dev"
  #     type = "CNAME"
  #     alias = {
  #        name                   = aws_elb.main.dns_name
  #        zone_id                = aws_elb.main.zone_id
  #        evaluate_target_health = true
  #
  #     }
  #   },
  # ]

  default = []
}

variable "failover_records" {
  description = "A list of failover records to create in the Hosted Zone."
  type        = any

  # Example:
  #
  # failover_records = [
  #     {
  #       type            = "A"
  #       set_identifier  = "prod"
  #       failover        = "PRIMARY"
  #       health_check_id = "A24GBC23AFGH"
  #       records         = ["172.217.22.99"]
  #     },
  #     {
  #       type            = "A"
  #       set_identifier  = "prod"
  #       failover        = "SECONDARY"
  #       records         = ["172.217.22.100"]
  #     }
  # ]

  default = []
}

variable "reference_name" {
  description = "The reference name used in Caller Reference (helpful for identifying single delegation set amongst others)."
  type        = string
  default     = ""
}

variable "skip_delegation_set_creation" {
  description = "Whether or not to create a delegation set and associate with the created zone."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to apply to all created resources that support tags."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }

  default = {}
}

variable "vpc_ids" {
  description = "A list of IDs of VPCs to associate with a private hosted zone. Conflicts with the delegation_set_id."
  type        = list(string)

  # Example:
  #
  # vpc_ids = [
  #   "vpc-56a5ec2c",
  #   "vpc-23a7efga"
  # ]

  default = []
}

variable "weighted_records" {
  description = "A list of weighted records to create in the Hosted Zone."
  type        = any

  # Example:
  #
  # weighted_records = [
  #   {
  #     type           = "A"
  #     weight         = 90
  #     set_identifier = "prod"
  #     records = [
  #       "216.239.32.117"
  #     ]
  #   },
  #   {
  #     type           = "A"
  #     weight         = 10
  #     set_identifier = "preview"
  #     records = [
  #       "216.239.32.118"
  #     ]
  #   }
  # ]

  default = []
}

variable "zone_id" {
  description = "a zone ID to create the records in"
  type        = string
  default     = null

  # Example:
  #
  # zone_id = "zoneid"
}
