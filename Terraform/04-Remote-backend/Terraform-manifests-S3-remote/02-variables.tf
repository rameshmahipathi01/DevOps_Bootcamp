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

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
  default     = "ramesh-docker-server"
}
