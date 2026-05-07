# VPC creation using Terraform

## Overview
This section demonstrates how to provision a custom AWS VPC using Terraform. The infrastructure includes public and private subnets, Internet Gateway, NAT Gateway, route tables, and subnet associations.

The goal is to understand Terraform fundamentals while learning AWS networking concepts such as VPC architecture, traffic flow, and subnet routing.

## What is a VPC?
A VPC (Virtual Private Cloud) is a logically isolated virtual network inside AWS where we can launch and manage AWS resources securely.

A VPC allows us to:

- Define our own private IP address range
- Create public and private subnets
- Control internet access
- Configure routing rules
- Isolate applications securely
- Design production-grade cloud infrastructure

A VPC acts like a private data center network inside AWS.

## AWS VPC Architecture
The following architecture represents a VPC with public and private networking components.

### Architecture
![architecture](screenshots/01-VPC-Architecture.png)
### VPC Traffic flow
![Traffic flow](screenshots/02-VPC-Traffic-Flow.png)
### Public and Private subnet routes
![Routes](screenshots/03-VPC-Public-Private-Routes.png)

## Concepts covered
### Public and Private Subnets
#### Public Subnet
A public subnet is a subnet that has direct internet access through the Internet Gateway.

Resources inside the public subnet:

- Can access the internet
- Can be accessed from the internet (if security groups allow)

Common resources placed in public subnet:

- Bastion Host
- Load Balancer
- NAT Gateway
- Public Web Servers

Public subnet route example:
```text
0.0.0.0/0 → Internet Gateway
```
#### Private Subnet
A private subnet does not have direct internet access through the Internet Gateway.

Resources inside the private subnet:

- Cannot be directly accessed from internet
- Can access internet outbound using NAT Gateway
- Are more secure for internal workloads

Common resources placed in private subnet:

- Application Servers
- Databases
- Internal Services
- Backend APIs

Private subnet route example:
```text
0.0.0.0/0 → NAT Gateway
```

#### Internet Gateway (IGW)
An Internet Gateway is attached to the VPC and enables communication between the VPC and the internet.

The Internet Gateway is mainly used by:
- Public subnets
- Internet-facing resources

Without an Internet Gateway:
- Public subnet resources cannot communicate with the internet.

#### NAT Gateway
A NAT Gateway allows resources in the private subnet to access the internet for outbound communication.

Example:
- Downloading software updates
- Accessing external APIs
- Pulling Docker images

Important:
- Internet cannot directly initiate inbound connections to private subnet resources through NAT Gateway.
- NAT Gateway only allows outbound internet access.

NAT Gateway is usually deployed inside a public subnet.

### Traffic Flow Understanding
#### Public Subnet Traffic Flow
```text
EC2 Instance
     ↓
Route Table
     ↓
Internet Gateway
     ↓
Internet
```
Resources in the public subnet communicate directly with the internet through the Internet Gateway.

#### Private Subnet Traffic Flow
```text
EC2 Instance
     ↓
Route Table
     ↓
NAT Gateway
     ↓
Internet Gateway
     ↓
Internet
```
Resources in the private subnet use the NAT Gateway for outbound internet access.

### Route Tables
Route tables define how traffic moves inside and outside the VPC.

Each subnet must be associated with a route table.

#### Public Route Table
Contains route:
```text
0.0.0.0/0 → Internet Gateway
```
This enables internet access for public subnet resources.

#### Private Route Table
Contains route:
```text
0.0.0.0/0 → NAT Gateway
```
This enables outbound internet access for private subnet resources.


## Terraform Concepts Covered
| Concept | Purpose |
|---|---|
| Terraform Block | Defines Terraform version and and provider requirements |
| Provider Block | Connects Terraform to AWS |
| Variables | Makes configuration reusable and dynamic |
| LOcals | Stores reusable local values |
| Data Sources | Fetches existing AWS information |
| Resource Blocks | Creates AWS infrastructure resources |
| Outputs | Displays useful output values |
| Local State | Stores Terraform state locally |


## Project Structure
``` text
terraform-manifests/
├── 01-versions.tf
├── 02-variables.tf
├── 03-datasources-and-locals.tf
├── 04-vpc.tf
└── 05-outputs.tf
```

### File Explanation
#### 01-versions.tf
This file contains:
- Terraform version configuration
- Required provider versions
- AWS provider configuration

This ensures the correct Terraform and provider versions are used for the project.

#### 02-variables.tf
This file defines input variables used throughout the project.

Variables help make Terraform configurations reusable and flexible across different environments.

Examples:
- AWS Region
- VPC CIDR
- Subnet CIDRs
- Environment tags

#### 03-datasources-and-locals.tf

This file contains:
- Data Sources
- Local values

#### Data Sources
Used to fetch information from AWS dynamically.

Example:
- Current AWS region
- Availability Zones

#### Locals
Used to define reusable local values and naming conventions.


#### 04-vpc.tf
This is the main infrastructure file.

It provisions:
- VPC
- Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Route Table Associations

This file contains the actual AWS infrastructure resource blocks.

#### 05-outputs.tf
This file defines output values displayed after Terraform deployment.

Examples:
- VPC ID
- Subnet IDs
- Route Table IDs

Outputs help retrieve important infrastructure information easily.


## VPC Creation (Terraform Commands used)
```bash
# Change Directory
cd terraform-manifests

# Terraform Initialize
terraform init 

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
```

### Validate Resource creation from AWS console
VPC, Subnets, NAT GW and RTs are created
