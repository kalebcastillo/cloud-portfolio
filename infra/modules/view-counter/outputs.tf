output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.portfolio_counter.function_name
}

output "lambda_function_url" {
  description = "HTTPS endpoint URL for the Lambda function"
  value       = aws_lambda_function_url.portfolio_counter.function_url
}
