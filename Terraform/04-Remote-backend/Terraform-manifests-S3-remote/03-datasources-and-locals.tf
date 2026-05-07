# Fetch Default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch Default Public Subnet
data "aws_subnets" "default_subnets" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Fetch Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}


locals {

  common_tags = {
    Owner       = "Ramesh"
    Environment = "dev"
    Project     = "DevOps Bootcamp"
    Terraform   = "true"
    DM          = "Bharath Advani"
    BU          = "IA"
    EndDate     = "2026-05-31"
  }
}
