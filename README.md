[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://www.mineiros.io/?ref=terraform-aws-route53)

[![Build Status](https://mineiros.semaphoreci.com/badges/terraform-aws-route53/branches/master.svg?style=shields)](https://mineiros.semaphoreci.com/projects/terraform-aws-route53)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-route53.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-route53/releases)
[![license](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-623CE4.svg)](https://github.com/hashicorp/terraform/releases)
[<img src="https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack">](https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg)

# terraform-aws-route53

A [Terraform](https://www.terraform.io) 0.12 module to create a scalable and highly available
[Amazon Route53](https://aws.amazon.com/route53/) Domain Name System (DNS) on
[Amazon Web Services (AWS)](https://aws.amazon.com/).

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Examples](#examples)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module offers a convenient way to create Route53 zones and records.

- **Zones**:
  You can either create a single zone by passing a string (e.G. `"mineiros.com"`) or multiple zones by passing a list
  of strings (e.G. `["mineiros.io", "mineiros.com]`) as the `name` parameter.
  `name = "mineiros.io"`. You can also share the same records among multiple zones. Please see the
  [example](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-same-records)
  for details.

- **Records**:
  Records can be shared among zones or be defined for a single zone only. We support
  [alias](https://aws.amazon.com/premiumsupport/knowledge-center/route-53-create-alias-records/),
  [weighted](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/TutorialLBRMultipleEC2InRegion.html)
  and [failover](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-configuring.html)
  records.

- **Default TTL for Records**
  Per default set a TTL (time to live) of 3600 seconds ( 1 hour ) for non-alias
  records. You can overwrite this behavior for records by setting the `ttl` parameter. To adjust the default value for
  TTL, please use the `default_ttl` parameter.
  Please see the [examples](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples)
  for details.

- **Delegation Set**:
  This module will create a delegation set for every zone by default. The default behavior can be disabled by setting
  `skip_delegation_set_creation` to `true`. If `skip_delegation_set_creation` isn't set to `true` and multiple zones
  are being created, all created zones will share the same delegation set.

## Getting Started

Most basic usage creating a Route53 zone and delegation set and
a record for `www` pointing to localhost.

```hcl
module "repository" {
  source  = "mineiros-io/route53/aws"
  version = "0.2.0"

  name = "mineiros.io"

  records = [
    {
      name    = "www"
      type    = "A"
      records = ["127.0.0.1"]
    },
  ]
}
```

## Examples

We offer a broad set of examples that can be used to quickly start using this module.

1. [Basic routing](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/basic_routing)
1. [Private hosted zone](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/private-hosted-zone)
1. [Multiple domains with different records](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-different-records)
1. [Multiple domains that share the same record set](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-same-records)
1. [Delegation set](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/delegation-set)
1. [Failover routing](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/failover-routing)
1. [Weighted routing](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/weighted-routing)

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)](https://semver.org/).

Using the given version number of `MAJOR.MINOR.PATCH`, we apply the following constructs:

1. Use the `MAJOR` version for incompatible changes.
1. Use the `MINOR` version when adding functionality in a backwards compatible manner.
1. Use the `PATCH` version when introducing backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- In the context of initial development, backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is
  increased. (Initial development)
- In the context of pre-release, backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is
  increased. (Pre-release)

## About Mineiros

Mineiros is a [DevOps as a Service](https://mineiros.io/?ref=terraform-aws-route53) company based in Berlin, Germany. We offer commercial support
for all of our projects and encourage you to reach out if you have any questions or need help.
Feel free to send us an email at [hello@mineiros.io](mailto:hello@mineiros.io).

We can also help you with:

- Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
- Consulting & training on AWS, Terraform and DevOps

## Reporting Issues

We use GitHub [Issues](https://github.com/mineiros-io/terraform-aws-route53/issues)
to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests](https://github.com/mineiros-io/terraform-aws-route53/pulls). If you'd like more information, please
see our [Contribution Guidelines](https://github.com/mineiros-io/terraform-aws-route53/blob/master/CONTRIBUTING.md).

## Makefile Targets

This repository comes with a handy
[Makefile](https://github.com/mineiros-io/terraform-aws-route53/blob/master/Makefile).
Run `make help` to see details on each available target.

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](https://github.com/mineiros-io/terraform-aws-route53/blob/master/LICENSE) for full details.

Copyright &copy; 2020 Mineiros GmbH
