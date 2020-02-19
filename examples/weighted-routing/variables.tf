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

variable "dev_targets" {
  description = "The records for the dev A record."
  type        = set(string)
  default = [
    "216.239.32.116"
  ]
}

variable "preview_targets" {
  description = "The records for the preview A record."
  type        = set(string)
  default = [
    "216.239.32.117"
  ]
}

variable "prod_targets" {
  description = "The records for the production A record."
  type        = set(string)
  default = [
    "216.239.32.118",
    "216.239.32.119"
  ]
}

variable "skip_delegation_set_creation" {
  description = "Whether or not to create a delegation set and associate with the created zone."
  type        = bool
  default     = true
}

variable "zone_name" {
  description = "The name of the hosted zone."
  type        = string
  default     = "mineiros.io"
}
