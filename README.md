# roboshop-infra-dev

The full RoboShop platform on AWS, deployed in phases. Thirteen numbered layers, each its own Terraform stack with its own state, composed from published modules. VPC first, CDN last, everything in between.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?logo=ansible&logoColor=white)
![HCL](https://img.shields.io/badge/HCL-844FBA?logo=terraform&logoColor=white)

## Overview

This is the deployment repo that glues the rest of the stack together. Each numbered directory is an isolated Terraform project: its own backend, its own state, its own `plan`/`apply` cycle. Downstream phases discover upstream resources through AWS data sources and SSM parameters, not through shared state.

## Phases

| # | Phase | Creates |
|---|---|---|
| 00 | `00-vpc` | VPC, subnets (public, private, database), IGW, route tables, peering (via [`terraform-aws-vpc`](https://github.com/sashank1064/terraform-aws-vpc)) |
| 10 | `10-sg` | One SG per service, declared in `sg.yaml`, created in a loop (via [`terraform-aws-securitygroup`](https://github.com/sashank1064/terraform-aws-securitygroup)) |
| 20 | `20-bastion` | Jump host with SSM access, user_data bootstrap (`bastion.sh`) |
| 30 | `30-vpn` | OpenVPN server for engineer access to private subnets |
| 40 | `40-databases` | MongoDB, Redis, MySQL, RabbitMQ instances in the database subnet tier (bootstrapped via `bootstrap.sh`) |
| 50 | `50-backend-alb` | Internal ALB for backend services, with listeners |
| 60 | `60-acm` | ACM certificates for the public domain |
| 60 | `60-catalogue`, `60-payment` | Per-component stacks for services I commonly iterate on |
| 70 | `70-frontend-alb` | Public-facing ALB with HTTPS listener |
| 80 | `80-user` | User service component stack |
| 90 | `90-components` | `for_each` over a `var.components` map, calling [`terraform-aws-roboshop`](https://github.com/sashank1064/terraform-aws-roboshop) for every remaining service |
| 91 | `91-cdn` | CloudFront distribution fronting the frontend ALB |

## Composition

Every phase sources modules straight from GitHub, pinned per phase:

```hcl
module "vpc" {
  source      = "git::https://github.com/sashank1064/terraform-aws-vpc.git?ref=main"
  Project     = var.Project
  environment = var.environment
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  is_peering_required   = true
}
```

Phase `90-components` is where the for-each loop composes the whole application tier:

```hcl
module "component" {
  for_each      = var.components
  source        = "git::https://github.com/sashank1064/terraform-aws-roboshop.git?ref=main"
  component     = each.key
  rule_priority = each.value.rule_priority
}
```

## Why phase-numbered directories

- **Separation of state.** A mistake in `60-catalogue` cannot corrupt the VPC state.
- **Reviewable blast radius.** A PR that touches `40-databases` is obviously a data-tier change.
- **Order is in the filesystem.** Any engineer opening the repo sees `00-vpc` first and `91-cdn` last. The build order is the directory listing.
- **Incremental `apply`.** You don't rebuild the VPC every time you tweak the catalogue ALB rule.

## Usage

```bash
# Create foundations in order
cd 00-vpc && terraform init && terraform apply
cd ../10-sg && terraform init && terraform apply
cd ../20-bastion && terraform init && terraform apply

# Then bring up data, load balancers, certs, components
cd ../40-databases && terraform init && terraform apply
cd ../50-backend-alb && terraform init && terraform apply
cd ../60-acm && terraform init && terraform apply
cd ../70-frontend-alb && terraform init && terraform apply
cd ../90-components && terraform init && terraform apply
cd ../91-cdn && terraform init && terraform apply
```

Destroys happen in reverse order.

## What this demonstrates

- **Module publishing and consumption.** Foundational modules are versioned repos, consumed via `git::` sources and pinned refs.
- **Phased IaC with isolated state.** Not one big `apply`.
- **Terraform plus Ansible, correctly layered.** Terraform provisions and tags; `ansible-pull` (from `ansible-roboshop-roles-tf`) configures the host on first boot via user_data.
- **Discovery over coupling.** Later phases find earlier resources by tag (data sources), not by wiring state outputs across stacks.
- **Parameter Store for secrets and IDs.** Shared values (domain, ALB ARNs, zone IDs) live in SSM, not in `terraform_remote_state`.

## Related repos

1. [`terraform-aws-vpc`](https://github.com/sashank1064/terraform-aws-vpc)
2. [`terraform-aws-securitygroup`](https://github.com/sashank1064/terraform-aws-securitygroup)
3. [`terraform-aws-instance`](https://github.com/sashank1064/terraform-aws-instance)
4. [`terraform-aws-roboshop`](https://github.com/sashank1064/terraform-aws-roboshop)
5. [`ansible-roboshop-roles-tf`](https://github.com/sashank1064/ansible-roboshop-roles-tf): the ansible-pull configuration layer
6. `roboshop-infra-dev` (this repo)
