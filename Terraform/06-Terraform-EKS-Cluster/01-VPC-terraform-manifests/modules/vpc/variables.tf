variable "environment_name" {

  description = "Environment name"

  type = string

  default = "dev"
}

variable "vpc_id" {

  description = "Existing VPC ID"

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
# Common Tags
# ------------------------------------------------------------------------------

variable "tags" {

  description = "Common tags"

  type = map(string)

  default = {

    Terraform = "true"

    Owner = "Ramesh"

    Environment = "dev"

    Project = "EKS Bootcamp"
  }
}
