[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Examples for using this Mineiros module

- [examples/basic-routing] Deploys a simple Route53 Zone with subdomain and CNAMES.
- [examples/delegation-set] Create two Route53 Zones that share the same delegation set ( a group of four nameservers ).
- [examples/failover-routing] Route53 Zone with records that have a failover routing policy attached.
- [examples/multiple-domains-different-records] Create two Route53 Zones with different records.
- [examples/multiple-domains-same-records] Create two Route53 Zones with same records.
- [examples/private-hosted-zone] Create a Route53 private zone and associate a single a-record.
- [examples/weighted-routing] Create a Route53 Zone and associate two weighted records.

<!-- References -->
[examples/basic-routing]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/basic-routing
[examples/delegation-set]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/delegation-set
[examples/failover-routing]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/failover-routing
[examples/multiple-domains-different-records]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-different-records
[examples/multiple-domains-same-records]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-same-records
[examples/private-hosted-zone]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/private-hosted-zone
[examples/weighted-routing]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/weighted-routing

[homepage]: https://mineiros.io/?ref=terraform-aws-route53

[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.14,%200.13,%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-route53.svg?label=latest&sort=semver

[releases-github]: https://github.com/mineiros-io/terraform-aws-route53/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
