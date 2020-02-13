# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "This is the name of the hosted zone."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "a_records" {
  description = "A list of A records to add to the created Route53 Zone."
  type        = list(any)
  # We unfortunately cannot use rich value types for now, we still need to wait for optional arguments to be released.
  #  type      = list(object({
  #    name    = string
  #    ttl     = number
  #    records = list(string)
  #  }))

  # Example:
  #
  # a_records = [
  #   {
  #     name = "www.example.com"
  #     ttl  = 300
  #     records = [
  #       "172.217.16.206",
  #       "172.217.18.163"
  #     ]
  #   }
  # ]
  default = []
}

variable "cname_records" {
  description = "A list of CNAME records to add to the created Route53 Zone."
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "create" {
  description = "Whether to create the Route53 Zone and it's associated resources."
  type        = bool
  default     = true
}

variable "comment" {
  description = "A comment for the hosted zone."
  type        = string
  default     = "Managed by Terraform"
}

variable "force_destroy" {
  description = "Whether to force destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
  type        = bool
  default     = false
}

variable "enable_google_mail_mx" {
  description = "Whether to create the standard set of Google Mail MX entries."
  type        = bool
  default     = false
}

variable "google_mail_mx_ttl" {
  description = "The TTL (time to live) used for the created Google Mail MX entries."
  type        = number
  default     = 3600
}

variable "google_suite_services" {
  description = ""
  type        = list(string)
  default     = ["mail", "cal", "docs"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "records" {
  type    = list(any)
  default = []
}
