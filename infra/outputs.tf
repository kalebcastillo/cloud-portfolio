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
