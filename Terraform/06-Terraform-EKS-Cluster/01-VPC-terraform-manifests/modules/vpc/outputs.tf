output "vpc_id" {

  description = "Existing VPC ID"

  value = data.aws_vpc.existing.id
}

# ------------------------------------------------------------------------------
# Public Subnet IDs
# ------------------------------------------------------------------------------

output "public_subnet_ids" {

  description = "List of Public Subnet IDs"

  value = [

    aws_subnet.public_1a.id,

    aws_subnet.public_1c.id
  ]
}

# ------------------------------------------------------------------------------
# Internet Gateway ID
# ------------------------------------------------------------------------------

output "internet_gateway_id" {

  description = "Existing Internet Gateway ID"

  value = data.aws_internet_gateway.existing_igw.id
}
