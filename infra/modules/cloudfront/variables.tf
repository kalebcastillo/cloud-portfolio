variable "environment" {
  description = "Environment name (test, prod, preview-pr-123, etc)"
  type        = string
}

variable "project_name" {
  description = "Project name for naming resources"
  type        = string
}

variable "s3_bucket_id" {
  description = "S3 bucket ID that will be the origin for CloudFront"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN for OAC bucket policy"
  type        = string
}

variable "s3_bucket_region" {
  description = "AWS region where S3 bucket is located"
  type        = string
}

variable "default_root_object" {
  description = "Default root object for the distribution (e.g., index.html)"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS on custom domain"
  type        = string
}

variable "domain_names" {
  description = "Domain names to associate with CloudFront"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
