terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "8byte-devops-tfstate-750281913869"
    key    = "8byte-devops/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = var.aws_region
}
