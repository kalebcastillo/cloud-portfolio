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

# S3 Static Website Module
module "s3_static_site" {
  source = "./modules/s3-static-site"

  environment  = var.environment
  project_name = var.project_name
  bucket_name  = "${var.environment}-${var.project_name}-website"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Static Website Hosting"
  }
}

