output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

# S3 Static Website Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the static website"
  value       = module.s3_static_site.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3_static_site.bucket_arn
}

# CloudFront Outputs
output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name (e.g., d123abc.cloudfront.net)"
  value       = module.cloudfront.domain_name
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = module.cloudfront.distribution_arn
}

# Route53 DNS Outputs
output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = module.route53.hosted_zone_id
}

output "root_domain_fqdn" {
  description = "Root domain FQDN pointing to CloudFront"
  value       = module.route53.root_domain_fqdn
}

# ACM Certificate Outputs
output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = module.acm.certificate_arn
}

output "certificate_domain_name" {
  description = "Domain name on the ACM certificate"
  value       = module.acm.certificate_domain_name
}

# View Counter Outputs
output "lambda_function_url" {
  description = "HTTPS endpoint URL for the view counter Lambda function"
  value       = module.view_counter.lambda_function_url
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for view counter"
  value       = module.view_counter.dynamodb_table_name
}

output "lambda_function_name" {
  description = "Name of the view counter Lambda function"
  value       = module.view_counter.lambda_function_name
}
