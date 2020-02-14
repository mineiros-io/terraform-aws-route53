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
  type        = list(any)

  # Example:
  #
  # cname_records = [
  #   {
  #     name = "www"
  #     ttl  = 3600
  #     records = [
  #       "example.com"
  #     ]
  #   }
  # ]

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

variable "create_google_mail_mx" {
  description = "Whether to create the standard set of Google Mail MX entries."
  type        = bool
  default     = false
}

variable "create_google_spf" {
  description = "Whether to create a SPF entry for Google Suite. Please notice that the entry needs to valiadte in Google Suite. https://support.google.com/a/answer/33786?hl=en"
  type        = bool
  default     = false
}

variable "delegation_set_id" {
  description = "The ID of the reusable delegation set whose NS records you want to assign to the hosted zone."
  type        = string
  default     = ""
}

variable "delegation_set_reference_name" {
  description = "The reference name used in Caller Reference (helpful for identifying single delegation set amongst others)."
  type        = string
  default     = ""
}

variable "google_mail_mx_ttl" {
  description = "The TTL (time to live) used for the created Google Mail MX entries."
  type        = number
  default     = 3600
}

variable "google_mail_dkim" {
  description = "Define the DKIM record to enhance security for outgoing mails with in Google Suite. Notice that you need to verify the DKIM record. https://support.google.com/a/answer/174126?hl=en"
  type        = map(string)

  # Example:
  #
  # google_mail_dkim = {
  #   "google._domainkey" = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoeaZAFNfAvwiMkuIHimJVODdtPX+9d7uVhFrML2S8m0GNd0c9w8Os5nQBeQaBmm1h7S/yxYrc5lcV5eaF1TgBmg9fYrwKXG8u1+gotmhFHhWl/GebYiUa/PchLAG+rrSav7lDlB3uTcbMGZUPQ3uuQOEwqi7SRsAFilAYFIkK+N6Crpis9LABFVAkrWsEbxOpVArxAdRpe6UuYAnS/Ge1uGOKu3L1kK5AGVN2HIkQPEllAQ0KY2yiPGfQXw8SA5ibZ0FjKlnw4amocZyBSLBlpHo9/qzLAy9JoByTOoZXdijikPY7zioSGIfOaY0RqSIpR338VXhHS76QMrDG5fLwQIDAQAB"
  # }

  default = {}
}

variable "force_destroy" {
  description = "Whether to force destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
  type        = bool
  default     = false
}

variable "google_suite_services_custom_aliases" {
  description = "A map of customized Google Suote service URLs. The key is the service name and the value is the desired custom subdomain. Please notice, that it takes additional steps to enable customized services URLs in Google Suite. https://support.google.com/a/answer/53340?hl=en"
  type        = map(string)

  # Example:
  #
  # google_suite_services = {
  #   mail     = "mail",
  #   calendar = "calendar",
  #   drive    = "drive",
  #   groups   = "groups"
  # }

  default = {}
}

variable "records" {
  description = "A list of records to create in the Hosted Zone."
  type        = list(any)
  default     = []
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
