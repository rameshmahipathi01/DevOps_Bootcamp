variable "public_subnet_1_cidr" {

  description = "CIDR for Public Subnet 1"

  type = string

  default = "10.0.16.0/24"
}

variable "public_subnet_2_cidr" {

  description = "CIDR for Public Subnet 2"

  type = string

  default = "10.0.34.0/24"
}
