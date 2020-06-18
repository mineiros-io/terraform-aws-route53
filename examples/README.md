[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Examples for using the AWS Route53 Module

We offer a broad set of examples that can be used to quickly start using this module.

- [example/basic-routing] Create a Route53 zone with subdomains and CNAMES.
- [example/private-hosted-zone] Create a Route53 private zone and associate a single A-record.
- [example/multiple-domains-different-records] Create two zones with different records.
- [example/multiple-domains-same-records] Create two zones with same records.
- [example/delegation-set] Create two Route53 zones that share the same delegation set (a group of four name servers).
- [example/failover-routing] Route53 zone with records that have a failover routing policy attached.
- [example/weighted-routing] Create a Route53 zone and associate two weightes records.

<!-- References -->
<!-- markdown-link-check-disable -->
[example/basic-routing]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/basic_routing
[example/private-hosted-zone]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/private-hosted-zone
[example/multiple-domains-different-records]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-different-records
[example/multiple-domains-same-records]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-same-records
[example/delegation-set]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/delegation-set
[example/failover-routing]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/failover-routing
[example/weighted-routing]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/weighted-routing
<!-- markdown-link-check-enable -->

[homepage]: https://mineiros.io/?ref=terraform-aws-route53

[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-route53.svg?label=latest&sort=semver

<!-- markdown-link-check-disable -->
[releases-github]: https://github.com/mineiros-io/terraform-aws-route53/releases
<!-- markdown-link-check-enable -->
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
