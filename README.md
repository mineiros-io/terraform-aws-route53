[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Build Status][badge-build]][build-status]
[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# terraform-aws-route53

A [Terraform] 0.12 module to create a scalable and highly available
[Amazon Route53] Domain Name System (DNS) on
[Amazon Web Services (AWS)][AWS].

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource Configuration](#extended-resource-configuration)
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

In contrast to the plain `aws_route53_XX` resources, this module offers a convenient way to create both Route53 zones and records.

These are some of our custom features:

- **Zones**:
  You can either create a single zone by passing a string (e.G. `"mineiros.com"`) or multiple zones by passing a list
  of strings (e.G. `["mineiros.io", "mineiros.com]`) as the `name` parameter.
  `name = "mineiros.io"`. You can also share the same records among multiple zones. Please see the
  example [multiple-domains-same-records]
  for details.

- **Records**:
  Records can be shared among zones or be defined for a single zone only. We support
  [alias],
  [weighted] and [failover] records.

- **Default TTL for Records**
  Per default, set a TTL (time to live) of 3600 seconds (1 hour) for non-alias
  records. You can overwrite this behavior for records by setting the `ttl` parameter. To adjust the default value for
  TTL, please use the `default_ttl` parameter.
  Please see the [examples] for details.

- **Delegation Set**:
  This module will create a delegation set for every zone by default. The default behavior can be disabled by setting
  `skip_delegation_set_creation` to `true`. If `skip_delegation_set_creation` isn't set to `true` and multiple zones
  are being created, all created zones will share the same delegation set.

## Getting Started

The most basic usage for creating a Route53 Zone, Delegation Set and a record for `www` pointing to localhost:

```hcl
module "repository" {
  source = "git@github.com:mineiros-io/terraform-aws-route53.git?ref=v0.0.1"

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

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: *(Optional `bool`)*

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_depends_on`**: *(Optional `list(any)`)*

  A list of external resources the module depends_on. Default is `[]`.

#### Main Resource Configuration

- **`name`**: **(Required `any`, Forces new resource)**

The name of the Hosted Zone. To create multiple Hosted Zones at once, pass a list of names, like  [\"zone1\", \"zone2\"].
Default `null`.

- **`name`**: *(Optional `any`)*

A list of records to create in the Hosted Zone.
Default `[]`.

- **`allow_overwrite`**: *(Optional `bool`)*

Default allow_overwrite value valid for all record sets.
Default `false`.

- **`comment`**: *(Optional `string`)*

  A comment for the Hosted Zone.
  Default `Managed by Terraform`.

- **`default_ttl`**: *(Optional `number`)*

  The default TTL (Time to Live) in seconds that will be used for all records that support the TTL parameter. Will be overwritten by the records TTL parameter if set.
  Default `3600`.

- **`delegation_set_id`**: *(Optional `string`)*

  The ID of the reusable delegation set whose NS records you want to assign to the hosted zone.
  Default `null`.

- **`force_destroy`**: *(Optional `bool`)*

  Whether to force destroy all records (possibly also ones managed outside of Terraform) in the Hosted Zone when destroying it.
  Default `false`.

#### Extended Resource Configuration

- **`reference_name`**: *(Optional `string`)*

  The reference name used in Caller Reference (helpful for identifying a single Delegation Set amongst others).
  Default `null`.

- **`skip_delegation_set_creation`**: *(Optional `bool`)*

  Whether or not to create a Delegation Set and associate with the created Hosted Zone.
  Default `false`.

- **`tags`**: *(Optional map(`string`))*

  A map of tags to apply to all created resources that support tags
  Default `{}`.

- **`vpc_ids`**: *(Optional list(`string`))*

  A list of IDs of VPCs to associate with a private hosted zone. Conflicts with the delegation_set_id.
  Default `[]`.

- **`zone_id`**: *(Optional `string`)*

  A Hosted Zone ID to create the records in.
  Default `null`.

## Module Attributes Reference

The following attributes are exported by the module:

- **`zone`**: The `aws_route53_zone` object(s)
- **`records`**: A list of `aws_route53_record` objects
- **`delegation_set`**: The outputs of the created delegation set
- **`module_enabled`**: Whether the module is enabled

## External Documentation

- AWS Documentation IAM:
  - Roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html

- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/iam_role.html

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Using the given version number of `MAJOR.MINOR.PATCH`, we apply the following constructs:

1. Use the `MAJOR` version for incompatible changes.
2. Use the `MINOR` version when adding functionality in a backwards compatible manner.
3. Use the `PATCH` version when introducing backwards compatible bug fixes.

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

[badge-build]: https://mineiros.semaphoreci.com/badges/terraform-aws-route53/branches/master.svg?style=shields&key=df11a416-f581-4d35-917a-fa3c2de2048e
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-route53.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

<!-- markdown-link-check-disable -->
[build-status]: https://mineiros.semaphoreci.com/projects/terraform-aws-route53
[releases-github]: https://github.com/mineiros-io/terraform-aws-route53/releases
<!-- markdown-link-check-enable -->
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg

[Terraform]: https://www.terraform.io
[Amazon Route53]: https://aws.amazon.com/route53/
[AWS]: https://aws.amazon.com/
[Semantic Versioning (SemVer)]: https://semver.org/
[alias]: https://aws.amazon.com/premiumsupport/knowledge-center/route-53-create-alias-records/
[weighted]: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/TutorialLBRMultipleEC2InRegion.html
[failover]: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-configuring.html

<!-- markdown-link-check-disable -->
[multiple-domains-same-records]: https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-same-records
[examples/example/main.tf]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/examples/example/main.tf
[variables.tf]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/examples
[Issues]: https://github.com/mineiros-io/terraform-aws-route53/issues
[LICENSE]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/LICENSE
[Makefile]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/Makefile
[Pull Requests]: https://github.com/mineiros-io/terraform-aws-route53/pulls
[Contribution Guidelines]: https://github.com/mineiros-io/terraform-aws-route53/blob/master/CONTRIBUTING.md
<!-- markdown-link-check-enable -->
