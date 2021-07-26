# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Add support for Terraform `v1.x`

## [0.5.0]

### Added

- Add support for Terraform `v0.15`

## [0.4.0] - 2021-04-22

### Added

- Add support for Terraform `v0.14`

### Fix

- Fix wrong wording in README.md

## [0.3.0]

### Added

- Add support for Terraform `v0.13`
- Add support for Terraform AWS Provider `v3`
- Prepare support for Terraform `v0.14`

## [0.2.3] - 2020-07-22

### Added

- Add `README.md` to `examples/`

### Fixed

- Update documentation

## [0.2.2] - 2020-06-13

### Changed

- Work around a terraform issue in `module_depends_on` argument.

## [0.2.1] - 2020-06-04

### Added

- Add `phony-targets` and `markdown-link-check` hooks.

### Changed

- Upgrade [build-tools](https://github.com/mineiros-io/build-tools) to
  [v0.5.3.](https://github.com/mineiros-io/build-tools/releases/tag/v0.5.3).
- Upgrade [pre-commit-hooks](https://github.com/mineiros-io/pre-commit-hooks) to
  [v0.1.4](https://github.com/mineiros-io/pre-commit-hooks/releases/tag/v0.1.4).
- Update logo and badges in README.md.

## [0.2.0] - 2020-05-04

### Added

- Implement `module_enabled` and `module_depends_on`.

## [0.1.0] - 2020-02-27

### Added

- Extended the basic routing example.
  The module now creates a working website that is hosted on S3.
- Added some basic documentation to this module.

## [0.0.6] - 2020-02-26

### Added

- Add alias record to basic routing example.

### Changed

- Upgrade pre-commit hooks to v0.1.0.

## [0.0.5] - 2020-02-26

### Added

- Add support for records with computed input parameters.

### Changed

- Merge records, failover records and weighted records into a single list records ( breaking change ).

## [0.0.4] - 2020-02-24

### Added

- Introduced `reference_name` to set the delegation set's optional reference name.

### Changed

- Do not set a default reference-name (breaking change).

## [0.0.3] - 2020-02-24

### Added

- Add support for weighted and failover records.

## [0.0.2] - 2020-02-18

### Added

- Add variable `default_ttl` to set a default TTL ( Time to Live) for all records
  and don't have an explicit TTL set. The default value is 3600 ( 1 hour ).
- Add toggle `enable_module` to dynamically switch the resource creation `on` and `off`.

## [0.0.1] - 2020-02-16

### Added

- Implement support for `aws_route53_zone` resource.
- Implement support for `aws_route53_record` resource.

<!-- markdown-link-check-disable -->

[unreleased]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.4.0...v0.5.0

<!-- markdown-link-check-enable -->

[0.4.0]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.2.3...v0.3.0
[0.2.3]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.0.6...v0.1.0
[0.0.6]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mineiros-io/terraform-aws-route53/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-aws-route53/releases/tag/v0.0.1
