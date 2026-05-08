# Terraform Modules
Modules convers Terraform resources to a re-usable Terraform code/modules.

## Overview
This project demonstrates how to convert a normal Terraform VPC configuration into a reusable Terraform module.

Instead of writing the same VPC code multiple times for:
- dev
- test
- prod

we create the VPC logic once inside a module and reuse it across environments.

This approach is widely used in real-time DevOps and Cloud environments to improve:
- reusability,
- maintainability,
- scalability,
- consistency.

## What is a Terraform Module?
A Terraform module is a collection of Terraform resources grouped together for a specific purpose.

Example:
- VPC module
- EC2 module
- EKS module
- Security Group module

A module helps avoid repeating the same infrastructure code again and again.

## Types of Terraform Modules

1. Root Module
The folder where Terraform commands are executed.

Example:
```hcl
terraform init
terraform plan
terraform apply
```

The root module:
- calls child modules,
- passes input variables,
- manages environment-specific values.

2. Child module
Reusable module called from the root module.

Example:
```hcl
module "vpc" {
  source = "./modules/vpc"
}
```
The child module contains actual reusable infrastructure logic.

## Why Use Terraform Modules?
Without modules:
- duplicated code,
- difficult maintenance,
- inconsistent environments,
- large Terraform files.

With modules:
- reusable code,
- cleaner structure,
- easier troubleshooting,
- better scalability.

## Real-Time Example
Instead of creating separate VPC code for:
- dev,
- test,
- prod,

We create
```hcl
modules/vpc
```
and call it multiple times with different values.

# Project Structure
```text
terraform-manifests/
│
├── modules/
│   └── vpc/
│       ├── datasources-and-locals.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
│       └── README.md
│
├── c1-versions.tf
├── c2-variables.tf
├── c3-vpc.tf
├── c4-outputs.tf
├── terraform.tfvars
└── README.md
```

## Understanding the Structure

### Root Module Files
#### c1-versions.tf

Defines: 
- Terraform version,
- provider version,
- remote backend configuration.

Example responsibilities:
- AWS provider setup,
- S3 backend setup.

#### c2-variables.tf

Contains root-level variables such as:
- environment name,
- region,
- subnet CIDRs,
- tags.

These values are passed into the child module.

#### c3-vpc.tf

Calls the reusable VPC module.

Example:
```hcl
module "vpc" {
  source = "./modules/vpc"
}
```
This file acts as the entry point for module execution.

#### c4-outputs.tf

Displays outputs from the child module.

Example:
- subnet IDs,
- VPC ID,
- route table IDs.

### Child Module Files

#### modules/vpc/main.tf

Contains reusable VPC resources such as:
- subnets,
- route tables,
- NAT Gateway,
- internet gateway.

This is the actual reusable infrastructure logic. 

#### modules/vpc/variables.tf

Defines module input variables.

Example:
- VPC CIDR,
- subnet CIDRs,
- tags.

#### modules/vpc/outputs.tf

Exports values from the module.

Example:

VPC ID,
subnet IDs,
NAT Gateway ID.

#### modules/vpc/datasources-and-locals.tf

Contains:

AWS data sources,
locals,
dynamic calculations.

Example:

availability zones,
subnet calculations,
naming conventions.

## Module Execution Flow

Terraform execution flow:
```text
Root Module
    ↓
Calls Child Module
    ↓
Child Module Creates Resources
    ↓
Outputs Returned to Root Module
```

## Module Reusability

Same module can be reused multiple times.
```hcl
module "dev_vpc" {
  source = "./modules/vpc"
}

module "prod_vpc" {
  source = "./modules/vpc"
}
```
Only input values change.

Infrastructure logic remains same.

## Module Sources

Terraform modules can be stored in:
| Source Type        | Example            |
| ------------------ | ------------------ |
| Local Path         | `./modules/vpc`    |
| GitHub             | Git repositories   |
| Terraform Registry | terraform.io       |
| Private Registry   | Enterprise modules |

## Local Module Example
```hcl
module "vpc" {
  source = "./modules/vpc"
}
```

## GitHub Module example
```hcl
module "vpc" {
  source = "github.com/org/vpc-module"
}
```

## Terraform registry example
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
}
```

## Benefits of Modularization
1. Reusability

- Same module reused across:
- - dev,
- - test,
- - prod.

2. Better Maintenance

- Fixing module updates all environments.

3. Cleaner Code

- Infrastructure becomes organized and readable.

4. Scalability

- Easy to extend with:
- - EC2,
- - ALB,
- - EKS,
- - RDS.

5. Standardization

- Teams follow same infrastructure patterns.

6. Collaboration

- Different teams can work independently using modules.


## Root Module vs Child Module
| Root Module                 | Child Module            |
| --------------------------- | ----------------------- |
| Executes Terraform commands | Contains reusable logic |
| Passes variables            | Creates resources       |
| Environment-specific        | Generic/reusable        |
| Calls modules               | Used by root module     |


## Important Real-Time Best Practices
1. Keep Modules Small

One module = one responsibility.

Examples:
- VPC module,
- EC2 module,
- EKS module.

2. Avoid Circular Dependencies

Bad:
```hcl
Module-A → Module-B
Module-B → Module-A
```
Always maintain
```hcl
one-way dependency flow
```

3. Version Modules

Production teams version modules.

Example:
```hcl
source = "git::ssh://repo/vpc-module?ref=v1.0.0"
```

4. Separate State Files

Avoid one huge shared state.

Better:
- network state,
- compute state,
- security state.


---
## Author
Ramesh Mahipathi