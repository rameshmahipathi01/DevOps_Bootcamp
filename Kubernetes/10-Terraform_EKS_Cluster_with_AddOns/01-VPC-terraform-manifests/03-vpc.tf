module "vpc" {

  source = "./modules/vpc"

  environment_name = var.environment_name

  vpc_id = var.existing_vpc_id

  public_subnet_1_cidr = var.public_subnet_1_cidr

  public_subnet_2_cidr = var.public_subnet_2_cidr

  tags = var.tags
}
