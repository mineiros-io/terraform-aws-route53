# ---------------------------------------------------------------------------------------------------------------------
# CREATE A ROUTE53 ZONE WITH SUBDOMAINS AND CNAMES
# This example creates a zone and records for the main domain and a subdomain.
#   - (www.)acme.com
#   - (www.)dev.acme.com
#
# The www. subdomains are implement through CNAMES and point on the A records.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Configure the AWS Provider
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

# ---------------------------------------------------------------------------------------------------------------------
# Create a public s3 bucket that will act as a website
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.website.bucket
  key    = "index.html"
  source = "index.html"
  etag   = filemd5("index.html")
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the zone and its records
# ---------------------------------------------------------------------------------------------------------------------

module "route53" {
  source = "../.."

  name = var.zone_name

  records = [
    {
      # We don't explicitly need to set names for records that match the zone
      type = "A"
      alias = {
        name                   = aws_s3_bucket.website.bucket
        zone_id                = aws_s3_bucket.website.hosted_zone_id
        evaluate_target_health = true
      }
    },
    {
      type = "CNAME"
      name = "www"
      records = [
        var.zone_name
      ]
    },
    {
      name    = "dev"
      type    = "A"
      ttl     = var.dev_ttl
      records = var.dev_targets
    },
    {
      type = "CNAME"
      name = "www.dev.${var.zone_name}"
      records = [
        "dev.${var.zone_name}"
      ]
    },
  ]
}
