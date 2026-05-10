terraform {

  required_version = ">= 1.0.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }

  # Remote Backend
  backend "s3" {

    bucket       = "tfstate-dev-ap-south-1-fez2tn"
    key          = "vpc/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {

  region = var.aws_region
}
