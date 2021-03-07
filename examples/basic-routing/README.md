[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Create a Route53 Zone with Subdomains and CNAMEs

The code in [main.tf] creates a Route53 Zone and Records for the main domain and a subdomain.
- `(www.)acme.com`
- `(www.)dev.acme.com`

The `www.` subdomains are implement through CNAMES and point on the A-Records.

```hcl
module "route53" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.4.0"

  name = "a-dev-mineiros.io"

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
        "mineiros.io"
      ]
    },
    {
      name    = "dev"
      type    = "A"
      ttl     = 1800
      records = ["203.0.113.200"]
    },
    {
      type = "CNAME"
      name = "www.dev.mineiros.io"
      records = [
        "dev.mineiros.io"
      ]
    },
  ]
}
```

## Running the example

### Cloning the repository

```bash
git clone https://github.com/mineiros-io/terraform-aws-route53.git
cd terraform-aws-route53/examples/example
```

### Initializing Terraform

Run `terraform init` to initialize the example and download providers and the module.

### Planning the example

Run `terraform plan` to see a plan of the changes.

### Applying the example

Run `terraform apply` to create the resources.
You will see a plan of the changes and Terraform will prompt you for approval to actually apply the changes.

### Destroying the example

Run `terraform destroy` to destroy all resources again.

<!-- References -->

<!-- markdown-link-check-disable -->
[main.tf]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/examples/basic-routing/main.tf
<!-- markdown-link-check-enable -->

[homepage]: https://mineiros.io/?ref=terraform-aws-route53
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.14,%200.13,%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
