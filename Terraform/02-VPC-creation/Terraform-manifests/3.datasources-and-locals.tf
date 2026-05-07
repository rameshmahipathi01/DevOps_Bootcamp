# Existing VPC Datasource
data "aws_vpc" "existing" {
  id = var.existing_vpc_id
}

# Availability Zones Datasource
data "aws_availability_zones" "available" {
  state = "available"
}

# Existing Internet Gateway Datasource
data "aws_internet_gateway" "existing_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

# Locals
locals {
  az = "ap-south-1a"

  common_tags = {
    Owner = "Ramesh"
    Env   = "Dev"
  }
}
