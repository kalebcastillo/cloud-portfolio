output "dynamodb_table_name" {
  description = "Name of the DynamoDB counter table"
  value       = aws_dynamodb_table.portfolio_counter.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB counter table"
  value       = aws_dynamodb_table.portfolio_counter.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.portfolio_counter.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.portfolio_counter.arn
}

output "lambda_function_url" {
  description = "HTTPS endpoint URL for the Lambda function"
  value       = aws_lambda_function_url.portfolio_counter.function_url
  sensitive   = false
}
