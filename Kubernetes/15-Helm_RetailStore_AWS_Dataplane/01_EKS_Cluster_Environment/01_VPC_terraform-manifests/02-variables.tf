# ------------------------------------------------------------------------------
# AWS Region
# ------------------------------------------------------------------------------

variable "aws_region" {

  description = "AWS region to deploy resources"

  type = string

  default = "ap-south-1"
}

# ------------------------------------------------------------------------------
# Environment Name
# ------------------------------------------------------------------------------

variable "environment_name" {

  description = "Environment name"

  type = string

  default = "dev"
}

# ------------------------------------------------------------------------------
# Existing VPC ID
# ------------------------------------------------------------------------------

variable "existing_vpc_id" {

  description = "Existing VPC ID where EKS subnets will be created"

  type = string
}

# ------------------------------------------------------------------------------
# Public Subnet CIDRs
# ------------------------------------------------------------------------------

variable "public_subnet_1_cidr" {

  description = "CIDR block for Public Subnet 1"

  type = string

  default = "10.0.16.0/24"
}

variable "public_subnet_2_cidr" {

  description = "CIDR block for Public Subnet 2"

  type = string

  default = "10.0.34.0/24"
}

# ------------------------------------------------------------------------------
# Common Resource Tags
# ------------------------------------------------------------------------------

variable "tags" {

  description = "Common tags for all resources"

  type = map(string)

  default = {

    Terraform = "true"

    Owner = "Ramesh"

    DM = "Bharath Advani"

    BU = "IA"

    Project = "EKS Bootcamp"

    Environment = "dev"

    EndDate = "2026-05-31"
  }
}
