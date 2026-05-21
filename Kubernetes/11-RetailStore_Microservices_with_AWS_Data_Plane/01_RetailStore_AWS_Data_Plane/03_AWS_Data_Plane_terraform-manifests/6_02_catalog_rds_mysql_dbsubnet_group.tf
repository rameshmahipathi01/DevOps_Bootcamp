# DB Subnet Group (using private subnets from VPC project)
resource "aws_db_subnet_group" "rds_public" {
  name       = "${local.name}-rds-public-subnets"
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  tags = {
    Name = "${local.name}-rds-public-subnets"
  }
}
