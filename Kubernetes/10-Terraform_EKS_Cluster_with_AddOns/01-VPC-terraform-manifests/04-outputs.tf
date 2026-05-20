output "vpc_id" {

  description = "Existing VPC ID"

  value = module.vpc.vpc_id
}

output "public_subnet_ids" {

  description = "Public Subnet IDs for EKS"

  value = module.vpc.public_subnet_ids
}

output "internet_gateway_id" {

  description = "Existing Internet Gateway ID"

  value = module.vpc.internet_gateway_id
}
