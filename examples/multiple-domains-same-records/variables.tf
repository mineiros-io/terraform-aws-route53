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

variable "testing_ttl" {
  description = "The TTL ( Time to Live ) for the testing A record."
  type        = number
  default     = 3600
}

variable "testing_targets" {
  description = "The records for the testing A record."
  type        = set(string)
  default = [
    "172.217.16.111"
  ]
}

variable "primary_ttl" {
  description = "The TTL ( Time to Live ) for the primary A record."
  type        = number
  default     = 3600
}

variable "primary_targets" {
  description = "The records for the primary A record."
  type        = set(string)
  default = [
    "172.217.16.206",
    "172.217.18.163"
  ]
}

variable "primary_txt_targets" {
  description = "The records for the primary TXT record."
  type        = set(string)
  default = [
    "Lorem ipsum"
  ]
}

variable "zone_a" {
  description = "The name of the first zone to create."
  type        = string
  default     = "mineiros.io"
}

variable "zone_b" {
  description = "The name of the second zone to create."
  type        = string
  default     = "mineiros.com"
}
