# Fetch Existing VPC
data "aws_vpc" "existing" {

  id = var.vpc_id
}

# Fetch Existing Internet Gateway attached to VPC
data "aws_internet_gateway" "existing_igw" {

  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

# Local Values
locals {

  az_1 = "ap-south-1a"

  az_2 = "ap-south-1c"

  common_tags = merge(var.tags, {

    Environment = var.environment_name
  })
}
