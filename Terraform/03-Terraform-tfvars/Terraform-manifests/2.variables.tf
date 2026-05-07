variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "environment_name" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "existing_vpc_id" {
  description = "Existing shared VPC ID"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.16.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.0.116.0/24"
}
