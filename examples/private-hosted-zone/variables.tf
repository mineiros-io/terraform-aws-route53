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

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region in which all resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "record_ttl" {
  description = "The TTL of the record."
  type        = number
  default     = 3600
}

variable "record_records" {
  description = "The records for the A record."
  type        = set(string)
  default = [
    "172.217.16.206",
    "172.217.18.163"
  ]
}

variable "zone_name" {
  description = "The name of the hosted zone."
  type        = string
  default     = "mineiros.io"
}
