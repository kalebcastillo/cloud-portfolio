#Variables 

variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
  default     = "cloud-portfolio"
}

variable "environment" {
  description = "Environment name (test, prod, or preview-*)"
  type        = string

  validation {
    condition     = can(regex("^(test|prod|preview-.*)$", var.environment))
    error_message = "Environment must be 'test', 'prod', or 'preview-*'"
  }
}

variable "domain_name" {
  description = "Root domain name for Route53 DNS records"
  type        = string
}

variable "alert_email" {
  description = "Email address to receive CloudWatch alerts"
  type        = string
  sensitive   = true
}

