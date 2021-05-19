[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Create two Route53 Zones with same Records

The code in [main.tf] creates two zones and attach the same set of records to
both. The zones will share the same delegation set.

```hcl
module "zones" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.5.0"

  name = [
    "mineiros.io",
    "mineiros.com"
  ]

  records = [
    {
      type = "A"
      ttl  = 3600
      records = [
        "203.0.113.200",
        "203.0.113.201"
      ]
    },
    {
      type = "TXT"
      ttl  = 300
      records = [
        "Lorem ipsum"
      ]
    },
    {
      name = "testing"
      type = "A"
      ttl  = 3600
      records = [
        "203.0.113.202"
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

[main.tf]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/examples/multiple-domains-same-records/main.tf
[homepage]: https://mineiros.io/?ref=terraform-aws-route53
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.14,%200.13,%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
