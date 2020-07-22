[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Build Status][badge-build]][build-status]
[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# terraform-aws-route53

A [Terraform](https://www.terraform.io) 0.12 module to create a scalable and highly available
[Amazon Route53](https://aws.amazon.com/route53/) Domain Name System (DNS) on
[Amazon Web Services (AWS)](https://aws.amazon.com/).

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Examples](#examples)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Route53 Zone](#route53-zone)
    - [Route53 Zone Records](#route53-zone-records)
      - [`records` Object Attributes](#records-object-attributes)
    - [Route53 Delegation Set](#route53-delegation-set)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
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
  You can either create a single zone by passing a string (e.G. `"mineiros.com"`)
  or multiple zones by passing a list of strings (e.G. `["mineiros.io", "mineiros.com]`)
  as the `name` parameter. `name = "mineiros.io"`. You can also share the same
  records among multiple zones. Please see the [example][same-records-example] for details.

- **Records**:
  Records can be shared among zones or be defined for a single zone only.
  We support [alias], [weighted] and [failover] records.

- **Default TTL for Records**
  Per default set a TTL (time to live) of 3600 seconds ( 1 hour ) for non-alias
  records. You can overwrite this behavior for records by setting the `ttl` parameter. To adjust the default value for
  TTL, please use the `default_ttl` parameter.
  Please see the [examples] for details.

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

1. [Basic routing](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/basic-routing)
2. [Private hosted zone](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/private-hosted-zone)
3. [Multiple domains with different records](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-different-records)
4. [Multiple domains that share the same record set](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-same-records)
5. [Delegation set](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/delegation-set)
6. [Failover routing](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/failover-routing)
7. [Weighted routing](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/weighted-routing)

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: *(Optional `bool`)*

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_depends_on`**: *(Optional `list(any)`)*

  A list of dependencies. Any object can be _assigned_ to this list to define a
  hidden external dependency. Default is `[]`.

#### Route53 Zone

- **`name`**: *(Required `any`, Forces new resource)*

  The name of the Hosted Zone. To create multiple Hosted Zones at once,
  pass a list of names `["zone1", "zone2"]`.

- **[`records`](#route53-zone-records)**: *(Optional `any`)*

  A list of records to create in the Hosted Zone.
  Default is `[]`.

- **`tags`**: *(Optional `map(string)`)*

  A map of tags to apply to all created resources that support tags.
  Default is `{}`.

- **`allow_overwrite`**: *(Optional `bool`)*

  Default allow_overwrite value valid for all record sets.
  Default is `false`.

- **`default_ttl`**: *(Optional `number`)*

  The default TTL ( Time to Live ) in seconds that will be used for all records
  that support the ttl parameter. Will be overwritten by the records ttl
  parameter if set. Default is `3600`.

- **`vpc_ids`**: *(Optional `list(string)`)*

  A list of IDs of VPCs to associate with a private hosted zone.
  Conflicts with the delegation_set_id. Default is `[]`.

- **`delegation_set_id`**: *(Optional `string`)*

  The ID of the reusable delegation set whose NS records you want to assign to
  the hosted zone. Default is `null`.

- **`zone_id`**: *(Optional `string`)*

  A zone ID to create the records in. Default is `null`.

- **`comment`**: *(Optional `string`)*

  A comment for the hosted zone. Default is `"Managed by Terraform"`.

- **`force_destroy`**: *(Optional `bool`)*

  Whether to force destroy all records (possibly managed outside of Terraform)
  in the zone when destroying the zone. Default is `false`.

#### Route53 Zone Records

##### [`records`](#route53-zone) Object Attributes

- **`name`**: *(Required `string`)*

  The name of the record.

- **`type`**: *(Required `string`)*

  The record type. Valid values are `A`, `AAAA`, `CAA`, `CNAME`, `MX`, `NAPTR`,
  `NS`, `PTR`, `SOA`, `SPF`, `SRV` and `TXT`.

- **`type`**: *(Optional `number`)*

  The TTL of the record.
  Default is `3600`.

- **`alias`**: *(Optional `object({name = string, zone_id = string, evaluate_target_health = bool})`)*

  An alias block. Expects `name`, `zone_id` and `evaluate_target_health`
  to be defined. Conflicts with `ttl` & `records`.
  Default is `null`.

- **`allow_overwrite`**: *(Optional `bool`)*

  Allow creation of this record in Terraform to overwrite an existing record,
  if any. This does not affect the ability to update the record in Terraform
  and does not prevent other resources within Terraform or manual Route 53
  changes outside Terraform from overwriting this record.
  This configuration is not recommended for most environments.
  Default is `false`.

- **`health_check_id`**: *(Optional `string`)*

  The health check the record should be associated with.
  Default is `null`.

- **`set_identifier`**: *(Optional `string`)*

  Unique identifier to differentiate records with routing policies from one
  another. Required if using `failover`, `geolocation`, `latency`, or `weighted routing`
  policies documented below.

- **`weight`**: *(Optional `number`)*

  A numeric value indicating the relative weight of the record. Will turn the
  record into a weighted record.
  For details see http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted

- **`failover`**: *(Optional `number`)*
  The failover type of the record. Will turn the record into a failover record.
  Possible values are `PRIMARY` and `SECONDARY`. A `PRIMARY` record will be
  served if its healthcheck is passing, otherwise the `SECONDARY` will be served.
  For details see http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-configuring-options.html#dns-failover-failover-rrsets

#### Route53 Delegation Set

- **`reference_name`**: *(Optional `string`)*
  The reference name used in Caller Reference (helpful for identifying single
  delegation set amongst others). Default is `null`.

- **`skip_delegation_set_creation`**: *(Optional `bool`)*
  Whether or not to create a delegation set and associate with the created zone.
  Default is `false`.

## Module Attributes Reference

The following attributes are exported by the module:

- **`zone`**: All `aws_route53_zone` objects.
- **`records`**: All `aws_route53_record` objects.
- **`delegation_set`**: The `aws_route53_delegation_set` object.
- **`module_enabled`**: Wether this module is enabled.

## External Documentation

- AWS Documentation Route53:
  - Zones: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-working-with.html
  - Records: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/rrsets-working-with.html

- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/route53_zone.html
  - https://www.terraform.io/docs/providers/aws/r/route53_record.html
  - https://www.terraform.io/docs/providers/aws/r/route53_delegation_set.html
  - https://www.terraform.io/docs/providers/aws/r/route53_zone_association.html
  - https://www.terraform.io/docs/providers/aws/r/route53_health_check.html

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

Mineiros is a [DevOps as a Service][homepage] company based in Berlin, Germany.
We offer commercial support for all of our projects and encourage you to reach out
if you have any questions or need help. Feel free to send us an email at [hello@mineiros.io] or join our [Community Slack channel][slack].

We can also help you with:

- Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
- Consulting & training on AWS, Terraform and DevOps

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020 [Mineiros GmbH][homepage]

<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-route53
[hello@mineiros.io]: mailto:hello@mineiros.io

[badge-build]: https://mineiros.semaphoreci.com/badges/terraform-aws-route53/branches/master.svg?style=shields
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-route53.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

[build-status]: https://mineiros.semaphoreci.com/projects/terraform-aws-route53
[releases-github]: https://github.com/mineiros-io/terraform-aws-route53/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg

[Terraform]: https://www.terraform.io
[AWS]: https://aws.amazon.com/
[Semantic Versioning (SemVer)]: https://semver.org/

[alias]: https://aws.amazon.com/premiumsupport/knowledge-center/route-53-create-alias-records/
[weighted]: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted
[failover]: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-configuring.html

[examples/example/main.tf]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/examples/example/main.tf
[variables.tf]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples
[same-records-example]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-same-records
[Issues]: https://github.com/mineiros-io/terraform-aws-route53/issues
[LICENSE]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/LICENSE
[Makefile]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/Makefile
[Pull Requests]: https://github.com/mineiros-io/terraform-aws-route53/pulls
[Contribution Guidelines]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/CONTRIBUTING.md
