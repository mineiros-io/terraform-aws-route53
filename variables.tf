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
  description = "(Required) The name of the Hosted Zone. To create multiple Hosted Zones at once, pass a list of names [\"zone1\", \"zone2\"]."
  type        = any

  # Examples:
  #
  # Single:   name = "example.com"
  # Multiple: name = ["example.com", "example.io"]
  #

  default = null
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "allow_overwrite" {
  description = "(Optional) Default allow_overwrite value valid for all record sets."
  type        = bool
  default     = false
}

variable "comment" {
  description = "(Optional) A comment for the hosted zone."
  type        = string
  default     = "Managed by Terraform"
}

variable "default_ttl" {
  description = "(Optional) The default TTL ( Time to Live ) in seconds that will be used for all records that support the ttl parameter. Will be overwritten by the records ttl parameter if set."
  type        = number
  default     = 3600
}

variable "delegation_set_id" {
  description = "(Optional) The ID of the reusable delegation set whose NS records you want to assign to the hosted zone."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "(Optional) Whether to force destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
  type        = bool
  default     = false
}

variable "records" {
  description = "(Optional) A list of records to create in the Hosted Zone."
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

variable "reference_name" {
  description = "(Optional) The reference name used in Caller Reference (helpful for identifying single delegation set amongst others)."
  type        = string
  default     = null
}

variable "skip_delegation_set_creation" {
  description = "(Optional) Whether or not to create a delegation set and associate with the created zone."
  type        = bool
  default     = false
}

variable "tags" {
  description = "(Optional) A map of tags to apply to all created resources that support tags."
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
  description = "(Optional) A list of IDs of VPCs to associate with a private hosted zone. Conflicts with the delegation_set_id."
  type        = list(string)

  # Example:
  #
  # vpc_ids = [
  #   "vpc-56a5ec2c",
  #   "vpc-23a7efga"
  # ]

  default = []
}

variable "zone_id" {
  description = "(Optional) A zone ID to create the records in"
  type        = string
  default     = null

  # Example:
  #
  # zone_id = "zoneid"
}

# ------------------------------------------------------------------------------
# OPTIONAL MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# See https://medium.com/mineiros/the-ultimate-guide-on-how-to-write-terraform-modules-part-1-81f86d31f024
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is true."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is []."
  default     = []
}
