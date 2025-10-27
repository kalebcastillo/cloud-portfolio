variable "project_name" {
  description = "The project name"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., test, prod)"
  type        = string
}

variable "alert_email" {
  description = "Email address to receive alerts"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function to monitor"
  type        = string
}
