[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Create two Route53 Zones with different Records

The code in [main.tf] creates two zones and different records using the
convenient `name = []` shortcut.
All created zones will share the same delegation set.

```hcl
# Create multiple zones with a single module
module "zones" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.4.0"

  name = [
    "mineiros.io",
    "mineiros.com"
  ]
}

# Create the records for zone a
module "zone_a_records" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.4.0"

  # Wrap the reference to the zone inside a try statement to prevent ugly exceptions if we run terraform destroy
  # without running a successful terraform apply before.
  zone_id = try(module.zones.zone["mineiros.io"].zone_id, null)

  records = [
    {
      type = "TXT"
      ttl  = 300
      records = [
        "Lorem ipsum"
      ]
    }
  ]
}

# Create the records for zone b
module "zone_b_records" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.4.0"

  zone_id = try(module.zones.zone["mineiros.com"].zone_id, null)

  records = [
    {
      type = "TXT"
      ttl  = 600
      records = [
        "Lorem ipsum",
        "Lorem ipsum dolor sit amet"
      ]
    }
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

[main.tf]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/examples/multiple-domains-different-records/main.tf
[homepage]: https://mineiros.io/?ref=terraform-aws-route53
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.14,%200.13,%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
