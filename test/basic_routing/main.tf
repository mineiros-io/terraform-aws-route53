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
  bucket         = var.bucket_name
  acl            = "public-read"
  hosted_zone_id = module.route53.zone[var.zone_name].zone_id

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
  policy = <<-EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "PublicReadForGetBucketObjects",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  }
  EOF

}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.website.bucket
  key    = "index.html"
  source = "index.html"
}

resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.website.bucket
  key    = "error.html"
  source = "error.html"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the zone and a mixed set of records
# ---------------------------------------------------------------------------------------------------------------------

module "route53" {
  source = "../.."

  name = var.zone_name

  records = [
    {
      # We don't explicitly need to set names for records that match the zone
      type = "A"
      alias = {
        name                   = aws_s3_bucket.website.website_endpoint
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
