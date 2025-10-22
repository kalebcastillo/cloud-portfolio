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
  description = "CloudFront price class (PriceClass_All, PriceClass_100, PriceClass_200)"
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_100", "PriceClass_200"], var.price_class)
    error_message = "price_class must be PriceClass_All, PriceClass_100, or PriceClass_200."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
