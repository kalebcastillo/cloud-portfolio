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
  }
}

# ACM Certificate Module (hosted zone already exists in Route53)
module "acm" {
  source = "./modules/acm"

  domain_name = var.domain_name

  tags = {
    Environment = var.environment
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
  certificate_arn     = module.acm.certificate_arn
  domain_names        = [var.domain_name]

  tags = {
    Environment = var.environment
  }

  depends_on = [module.s3_static_site, module.acm]
}

# Route53 DNS Module (points domain to CloudFront)
module "route53" {
  source = "./modules/route53"

  domain_name            = var.domain_name
  cloudfront_domain_name = module.cloudfront.domain_name

  tags = {
    Environment = var.environment
  }

  depends_on = [module.cloudfront]
}

# View Counter
module "view_counter" {
  source = "./modules/view-counter"

  environment = var.environment

  tags = {
    Environment = var.environment
  }
}

# CloudWatch Monitoring and Alerts
module "cloudwatch_monitoring" {
  source = "./modules/cloudwatch-monitoring"

  project_name         = var.project_name
  environment          = var.environment
  alert_email          = var.alert_email
  lambda_function_name = module.view_counter.lambda_function_name

  depends_on = [module.view_counter]
}
