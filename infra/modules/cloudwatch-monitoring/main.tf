# SNS Topic
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-${var.environment}-alerts"

  tags = {
    Name        = "${var.project_name}-${var.environment}-alerts"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Monitoring and Alerting"
  }
}

# SNS Topic Subscription
resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Alarm for monthly spending estimate
resource "aws_cloudwatch_metric_alarm" "monthly_spend" {
  alarm_name          = "${var.project_name}-${var.environment}-monthly-spend"
  alarm_description   = "Alert when estimated monthly spend exceeds $2"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  statistic           = "Maximum"
  period              = 86400 # 1 day
  evaluation_periods  = 1
  threshold           = 2
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = {
    Name        = "${var.project_name}-${var.environment}-monthly-spend"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Monitoring and Alerting"
  }
}

# CloudWatch Alarm for Lambda errors
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.project_name}-${var.environment}-lambda-errors"
  alarm_description   = "Alert when view counter Lambda has errors"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = 300 # 5 minutes
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-lambda-errors"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Monitoring and Alerting"
  }
}
