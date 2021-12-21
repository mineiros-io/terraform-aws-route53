header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-aws-route53"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-aws-route53/actions/workflows/main.yml/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-aws-route53/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-route53.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-aws-route53/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/terraform-1.x%20|%200.15%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-aws-provider" {
    image = "https://img.shields.io/badge/AWS-3%20and%202.45+-F8991D.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-aws/releases"
    text  = "AWS Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-aws-route53"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create a scalable and highly available
    [Amazon Route53](https://aws.amazon.com/route53/) Domain Name System (DNS) on
    [Amazon Web Services (AWS)](https://aws.amazon.com/).

    ***This module supports Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above
    and is compatible with the terraform AWS provider v3 as well as v2.45 and above.***
  END

  section {
    title   = "Module Features"
    content = <<-END
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
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
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
    END
  }

  section {
    title   = "Examples"
    content = <<-END
      We offer a broad set of examples that can be used to quickly start using this module.

      1. [Basic routing](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/basic-routing)
      2. [Private hosted zone](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/private-hosted-zone)
      3. [Multiple domains with different records](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-different-records)
      4. [Multiple domains that share the same record set](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-same-records)
      5. [Delegation set](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/delegation-set)
      6. [Failover routing](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/failover-routing)
      7. [Weighted routing](https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/weighted-routing)
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Top-level Arguments"

      section {
        title = "Module Configuration"

        variable "module_enabled" {
          type        = bool
          default     = true
          description = <<-END
            Specifies whether resources in the module will be created.
          END
        }

        variable "module_depends_on" {
          type        = list(any)
          default     = []
          description = <<-END
            A list of dependencies. Any object can be _assigned_ to this list to define a
              hidden external dependency.
          END
        }
      }

      section {
        title = "Route53 Zone"

        variable "name" {
          required       = true
          type           = any
          readme_example = <<-END
            Single:   name = "example.com"
            Multiple: name = ["example.com", "example.io"]
          END
          description    = <<-END
            The name of the Hosted Zone. To create multiple Hosted Zones at once,
              pass a list of names `["zone1", "zone2"]`. Forces new resource.
          END
        }

        variable "records" {
          type        = any
          default     = []
          description = <<-END
            A list of records to create in the Hosted Zone.
          END

          attribute "name" {
            required    = true
            type        = string
            description = <<-END
              The name of the record.
            END
          }

          attribute "type" {
            required    = true
            type        = string
            description = <<-END
              The record type. Valid values are `A`, `AAAA`, `CAA`, `CNAME`, `MX`, `NAPTR`, `NS`, `PTR`, `SOA`, `SPF`, `SRV` and `TXT`.
            END
          }

          attribute "ttl" {
            type        = number
            default     = 3600
            description = <<-END
              The TTL of the record.
            END
          }

          attribute "alias" {
            type        = any
            readme_type = "object(alias)"
            description = <<-END
              An alias block. Expects `name`, `zone_id` and `evaluate_target_health` to be defined. Conflicts with `ttl` & `records`.
            END

            attribute "name" {
              required = true
              type = string
              description = <<-END
                DNS domain name for a CloudFront distribution, S3 bucket, ELB, or another resource record set in this hosted zone.
              END
            }

            attribute "zone_id" {
              required = true
              type = string
              description = <<-END
                Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone.
              END
            }

            attribute "evaluate_target_health" {
              type = bool
              description = <<-END
                Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. 
              END
            }
          }

          attribute "allow_overwrite" {
            type        = bool
            default     = false
            description = <<-END
              Allow creation of this record in Terraform to overwrite an existing record, if any. This does not affect the ability to update the record in Terraform and does not prevent other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record.
              This configuration is not recommended for most environments.
            END
          }

          attribute "health_check_id" {
            type        = string
            description = <<-END
              The health check the record should be associated with.
            END
          }

          attribute "set_identifier" {
            type        = string
            description = <<-END
              Unique identifier to differentiate records with routing policies from one another. Required if using `failover`, `geolocation`, `latency`, or `weighted routing` policies documented below.
            END
          }

          attribute "weight" {
            type        = number
            description = <<-END
              A numeric value indicating the relative weight of the record. Will turn the record into a weighted record.
              For details see http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted
            END
          }

          attribute "failover" {
            type        = number
            description = <<-END
              The failover type of the record. Will turn the record into a failover record.
              Possible values are `PRIMARY` and `SECONDARY`. A `PRIMARY` record will be served if its healthcheck is passing, otherwise the `SECONDARY` will be served.
              For details see http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-configuring-options.html#dns-failover-failover-rrsets
            END
          }
        }

        variable "tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags to apply to all created resources that support tags.
          END
        }

        variable "allow_overwrite" {
          type        = bool
          default     = false
          description = <<-END
            Default allow_overwrite value valid for all record sets.
          END
        }

        variable "default_ttl" {
          type        = number
          default     = 3600
          description = <<-END
            The default TTL ( Time to Live ) in seconds that will be used for all records that support the ttl parameter. Will be overwritten by the records ttl parameter if set.
          END
        }

        variable "vpc_ids" {
          type        = list(string)
          default     = []
          description = <<-END
            A list of IDs of VPCs to associate with a private hosted zone.
            Conflicts with the delegation_set_id.
          END
        }

        variable "delegation_set_id" {
          type        = string
          description = <<-END
            The ID of the reusable delegation set whose NS records you want to assign to the hosted zone.
          END
        }

        variable "zone_id" {
          type        = string
          description = <<-END
            A zone ID to create the records in.
          END
        }

        variable "comment" {
          type        = string
          default     = "Managed by Terraform"
          description = <<-END
            A comment for the hosted zone.
          END
        }

        variable "force_destroy" {
          type        = bool
          default     = false
          description = <<-END
            Whether to force destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone.
          END
        }
      }

      section {
        title = "Route53 Delegation Set"

        variable "reference_name" {
          type        = string
          description = <<-END
            The reference name used in Caller Reference (helpful for identifying single delegation set amongst others).
          END
        }

        variable "skip_delegation_set_creation" {
          type        = bool
          default     = false
          description = <<-END
            Whether or not to create a delegation set and associate with the created zone.
          END
        }
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported by the module:

      - **`zone`**: All `aws_route53_zone` objects.
      - **`records`**: All `aws_route53_record` objects.
      - **`delegation_set`**: The `aws_route53_delegation_set` object.
      - **`module_enabled`**: Wether this module is enabled.
    END
  }

  section {
    title = "External Documentation"

    section {
      title   = "AWS Documentation Route53"
      content = <<-END
        - Zones: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-working-with.html
        - Records: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/rrsets-working-with.html
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_delegation_set
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      Mineiros is a [DevOps as a Service][homepage] company based in Berlin, Germany.
      We offer commercial support for all of our projects and encourage you to reach out
      if you have any questions or need help. Feel free to send us an email at [hello@mineiros.io] or join our [Community Slack channel][slack].

      We can also help you with:

      - Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
      - Consulting & training on AWS, Terraform and DevOps
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-aws-route53"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/actions/workflows/main.yml/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-route53.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/terraform-1.x%20|%200.15%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "badge-tf-aws" {
    value = "https://img.shields.io/badge/AWS-3%20and%202.45+-F8991D.svg?logo=terraform"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "Terraform" {
    value = "https://www.terraform.io"
  }
  ref "AWS" {
    value = "https://aws.amazon.com/"
  }
  ref "Semantic Versioning (SemVer)" {
    value = "https://semver.org/"
  }
  ref "alias" {
    value = "https://aws.amazon.com/premiumsupport/knowledge-center/route-53-create-alias-records/"
  }
  ref "weighted" {
    value = "https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted"
  }
  ref "failover" {
    value = "https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-configuring.html"
  }
  ref "examples/example/main.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/blob/master/examples/example/main.tf"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/blob/master/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples"
  }
  ref "same-records-example" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/tree/master/examples/multiple-domains-same-records"
  }
  ref "Issues" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/issues"
  }
  ref "LICENSE" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/blob/master/LICENSE"
  }
  ref "Makefile" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/blob/master/Makefile"
  }
  ref "Pull Requests" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/pulls"
  }
  ref "Contribution Guidelines" {
    value = "https://github.com/mineiros-io/terraform-aws-route53/blob/master/CONTRIBUTING.md"
  }
}
