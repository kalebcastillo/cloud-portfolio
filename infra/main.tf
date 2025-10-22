terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # These values are provided by backend config files during local development and GitHub Action workflows (*-backend.hcl)
    # bucket
    # key            
    # dynamodb_table 
    # region         
    # encrypt      
  }
}

provider "aws" {
  region = var.aws_region
}

