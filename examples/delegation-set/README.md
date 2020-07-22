[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Create two Route53 Zones that share the same Delegation Set ( a group of four Nameservers )

The code in [main.tf] creates set of four authoritative name servers that you can use with more than one hosted zone.
By default, Route 53 assigns a random selection of name servers to each new hosted zone.
To make it easier to migrate DNS service to Route 53 for a large number of domains,
you can create a reusable delegation set and then associate the reusable delegation set with new hosted zones.

```hcl
module "route53-zone-with-delegation-set" {
  source  = "mineiros-io/route53/aws"
  version = "0.2.2"

  name = "mineiros.io"
}

module "route53-zone" {
  source  = "mineiros-io/route53/aws"
  version = "0.2.2"

  name              = "mineiros.com"
  delegation_set_id = module.route53-zone-with-delegation-set.delegation_set.id
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

[main.tf]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/examples/delegation-set/main.tf
[homepage]: https://mineiros.io/?ref=terraform-aws-route53
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
