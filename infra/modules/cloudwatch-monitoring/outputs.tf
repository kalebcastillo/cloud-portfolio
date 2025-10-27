output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "monthly_spend_alarm_arn" {
  description = "ARN of the monthly spend CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.monthly_spend.arn
}

output "lambda_errors_alarm_arn" {
  description = "ARN of the Lambda errors CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.lambda_errors.arn
}
