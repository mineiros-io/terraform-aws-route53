[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-aws-route53)

[![Build Status](https://github.com/mineiros-io/terraform-aws-route53/actions/workflows/main.yml/badge.svg)](https://github.com/mineiros-io/terraform-aws-route53/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-route53.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-route53/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-1.x%20|%200.15%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-3%20and%202.45+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-aws-route53

A [Terraform](https://www.terraform.io) module to create a scalable and highly available
[Amazon Route53](https://aws.amazon.com/route53/) Domain Name System (DNS) on
[Amazon Web Services (AWS)](https://aws.amazon.com/).

***This module supports Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above
and is compatible with the terraform AWS provider v3 as well as v2.45 and above.***


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Examples](#examples)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Route53 Zone](#route53-zone)
    - [Route53 Delegation Set](#route53-delegation-set)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [AWS Documentation Route53](#aws-documentation-route53)
  - [Terraform AWS Provider Documentation](#terraform-aws-provider-documentation)
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
module "route53" {
  source  = "mineiros-io/route53/aws"
  version = "~> 0.6.0"

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

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(any)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to define a
  hidden external dependency.

  Default is `[]`.

#### Route53 Zone

- [**`name`**](#var-name): *(**Required** `any`)*<a name="var-name"></a>

  The name of the Hosted Zone. To create multiple Hosted Zones at once,
  pass a list of names `["zone1", "zone2"]`. Forces new resource.

  Example:

  ```hcl
  Single:   name = "example.com"
  Multiple: name = ["example.com", "example.io"]
  ```

- [**`records`**](#var-records): *(Optional `any`)*<a name="var-records"></a>

  A list of records to create in the Hosted Zone.

  Default is `[]`.

  The object accepts the following attributes:

  - [**`name`**](#attr-name-records): *(**Required** `string`)*<a name="attr-name-records"></a>

    The name of the record.

  - [**`type`**](#attr-type-records): *(**Required** `string`)*<a name="attr-type-records"></a>

    The record type. Valid values are `A`, `AAAA`, `CAA`, `CNAME`, `MX`, `NAPTR`, `NS`, `PTR`, `SOA`, `SPF`, `SRV` and `TXT`.

  - [**`ttl`**](#attr-ttl-records): *(Optional `number`)*<a name="attr-ttl-records"></a>

    The TTL of the record.

    Default is `3600`.

  - [**`alias`**](#attr-alias-records): *(Optional `object(alias)`)*<a name="attr-alias-records"></a>

    An alias block. Expects `name`, `zone_id` and `evaluate_target_health` to be defined. Conflicts with `ttl` & `records`.

    The object accepts the following attributes:

    - [**`name`**](#attr-name-alias-records): *(**Required** `string`)*<a name="attr-name-alias-records"></a>

      DNS domain name for a CloudFront distribution, S3 bucket, ELB, or another resource record set in this hosted zone.

    - [**`zone_id`**](#attr-zone_id-alias-records): *(**Required** `string`)*<a name="attr-zone_id-alias-records"></a>

      Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone.

    - [**`evaluate_target_health`**](#attr-evaluate_target_health-alias-records): *(Optional `bool`)*<a name="attr-evaluate_target_health-alias-records"></a>

      Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set.

  - [**`allow_overwrite`**](#attr-allow_overwrite-records): *(Optional `bool`)*<a name="attr-allow_overwrite-records"></a>

    Allow creation of this record in Terraform to overwrite an existing record, if any. This does not affect the ability to update the record in Terraform and does not prevent other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record.
    This configuration is not recommended for most environments.

    Default is `false`.

  - [**`health_check_id`**](#attr-health_check_id-records): *(Optional `string`)*<a name="attr-health_check_id-records"></a>

    The health check the record should be associated with.

  - [**`set_identifier`**](#attr-set_identifier-records): *(Optional `string`)*<a name="attr-set_identifier-records"></a>

    Unique identifier to differentiate records with routing policies from one another. Required if using `failover`, `geolocation`, `latency`, or `weighted routing` policies documented below.

  - [**`weight`**](#attr-weight-records): *(Optional `number`)*<a name="attr-weight-records"></a>

    A numeric value indicating the relative weight of the record. Will turn the record into a weighted record.
    For details see http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted

  - [**`failover`**](#attr-failover-records): *(Optional `number`)*<a name="attr-failover-records"></a>

    The failover type of the record. Will turn the record into a failover record.
    Possible values are `PRIMARY` and `SECONDARY`. A `PRIMARY` record will be served if its healthcheck is passing, otherwise the `SECONDARY` will be served.
    For details see http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-configuring-options.html#dns-failover-failover-rrsets

- [**`tags`**](#var-tags): *(Optional `map(string)`)*<a name="var-tags"></a>

  A map of tags to apply to all created resources that support tags.

  Default is `{}`.

- [**`allow_overwrite`**](#var-allow_overwrite): *(Optional `bool`)*<a name="var-allow_overwrite"></a>

  Default allow_overwrite value valid for all record sets.

  Default is `false`.

- [**`default_ttl`**](#var-default_ttl): *(Optional `number`)*<a name="var-default_ttl"></a>

  The default TTL ( Time to Live ) in seconds that will be used for all records that support the ttl parameter. Will be overwritten by the records ttl parameter if set.

  Default is `3600`.

- [**`vpc_ids`**](#var-vpc_ids): *(Optional `list(string)`)*<a name="var-vpc_ids"></a>

  A list of IDs of VPCs to associate with a private hosted zone.
Conflicts with the delegation_set_id.

  Default is `[]`.

- [**`delegation_set_id`**](#var-delegation_set_id): *(Optional `string`)*<a name="var-delegation_set_id"></a>

  The ID of the reusable delegation set whose NS records you want to assign to the hosted zone.

- [**`zone_id`**](#var-zone_id): *(Optional `string`)*<a name="var-zone_id"></a>

  A zone ID to create the records in.

- [**`comment`**](#var-comment): *(Optional `string`)*<a name="var-comment"></a>

  A comment for the hosted zone.

  Default is `"Managed by Terraform"`.

- [**`force_destroy`**](#var-force_destroy): *(Optional `bool`)*<a name="var-force_destroy"></a>

  Whether to force destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone.

  Default is `false`.

#### Route53 Delegation Set

- [**`reference_name`**](#var-reference_name): *(Optional `string`)*<a name="var-reference_name"></a>

  The reference name used in Caller Reference (helpful for identifying single delegation set amongst others).

- [**`skip_delegation_set_creation`**](#var-skip_delegation_set_creation): *(Optional `bool`)*<a name="var-skip_delegation_set_creation"></a>

  Whether or not to create a delegation set and associate with the created zone.

  Default is `false`.

## Module Outputs

The following attributes are exported by the module:

- **`zone`**: All `aws_route53_zone` objects.
- **`records`**: All `aws_route53_record` objects.
- **`delegation_set`**: The `aws_route53_delegation_set` object.
- **`module_enabled`**: Wether this module is enabled.

## External Documentation

### AWS Documentation Route53

- Zones: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-working-with.html
- Records: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/rrsets-working-with.html

### Terraform AWS Provider Documentation

- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_delegation_set
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check

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

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-route53
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-aws-route53/actions/workflows/main.yml/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-route53.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.15%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-tf-aws]: https://img.shields.io/badge/AWS-3%20and%202.45+-F8991D.svg?logo=terraform
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[build-status]: https://github.com/mineiros-io/terraform-aws-route53/actions
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
