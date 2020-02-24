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

variable "health_check_failure_threshold" {
  description = "The number of consecutive health checks that an endpoint must pass or fail."
  type        = number
  default     = 5
}

variable "health_check_port" {
  description = "The port of the endpoint to be checked."
  type        = number
  default     = 80
}

variable "health_check_protocol" {
  description = "The protocol the healthcheck should use to test the targets health. Must be either HTTP or HTTPS."
  type        = string
  default     = "HTTP"
}

variable "health_check_request_interval" {
  description = "The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request."
  type        = number
  default     = 30
}

variable "health_check_resource_path" {
  description = "The path that you want Amazon Route 53 to request when performing health checks."
  type        = string
  default     = "/"
}

variable "primary_record_records" {
  description = "The records for primary Route53 A record."
  type        = set(string)
  default = [
    "172.217.16.174"
  ]
}

variable "secondary_record_records" {
  description = "The records for secondary Route53 A record."
  type        = set(string)
  default = [
    "172.217.22.99",
    "172.217.22.100"
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
