output "vpc_id" {
  description = "Existing VPC ID"
  value       = data.aws_vpc.existing.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat.id
}

output "internet_gateway_id" {
  description = "Existing Internet Gateway ID"
  value       = data.aws_internet_gateway.existing_igw.id
}
