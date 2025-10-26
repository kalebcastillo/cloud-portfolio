variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
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
