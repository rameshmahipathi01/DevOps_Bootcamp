terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }

  backend "s3" {
    bucket  = "tfstate-dev-ap-south-1-fez2tn"
    key     = "ec2/dev/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-south-1"
}

