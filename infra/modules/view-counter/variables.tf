variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of existing IAM role for Lambda execution"
  type        = string
  default     = "arn:aws:iam::155139033148:role/lambda-execution-role"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "allowed_origins" {
  description = "Allowed origins for Lambda Function URL CORS"
  type        = list(string)
  default     = ["https://kalebcastillo.com", "https://test.kalebcastillo.com"]
}
