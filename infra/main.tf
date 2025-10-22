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

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Static Website Hosting"
  }
}

# CloudFront CDN Module
module "cloudfront" {
  source = "./modules/cloudfront"

  environment         = var.environment
  project_name        = var.project_name
  s3_bucket_id        = module.s3_static_site.bucket_id
  s3_bucket_arn       = module.s3_static_site.bucket_arn
  s3_bucket_region    = module.s3_static_site.bucket_region
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "CDN Distribution"
  }

  depends_on = [module.s3_static_site]
}

# Route53 DNS Module
module "route53" {
  source = "./modules/route53"

  domain_name            = var.domain_name
  cloudfront_domain_name = module.cloudfront.domain_name
  cloudfront_zone_id     = "Z2FDTNDATAQYW2"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "DNS Records"
  }

  depends_on = [module.cloudfront]
}
