# DynamoDB Table for portfolio view counter
resource "aws_dynamodb_table" "portfolio_counter" {
  name           = "${var.environment}-portfolio-counter"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${var.environment}-portfolio-counter"
    Environment = var.environment
  }
}

# Initial item in DynamoDB table
resource "aws_dynamodb_table_item" "counter_initial" {
  table_name = aws_dynamodb_table.portfolio_counter.name
  hash_key   = aws_dynamodb_table.portfolio_counter.hash_key

  item = jsonencode({
    id    = { S = "0" }
    views = { N = "0" }
  })

  depends_on = [aws_dynamodb_table.portfolio_counter]
}

# Create a minimal IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.environment}-portfolio-counter-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Inline policy for DynamoDB access
resource "aws_iam_role_policy" "lambda_dynamodb" {
  name = "${var.environment}-portfolio-counter-dynamodb"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Resource = aws_dynamodb_table.portfolio_counter.arn
      }
    ]
  })
}

# Lambda function for view counter
resource "aws_lambda_function" "portfolio_counter" {
  filename      = "${path.module}/lambda_function.zip"
  function_name = "${var.environment}-portfolio-counter"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.portfolio_counter.name
    }
  }

  tags = {
    Name        = "${var.environment}-portfolio-counter"
    Environment = var.environment
  }
}

# Lambda Function URL
resource "aws_lambda_function_url" "portfolio_counter" {
  function_name          = aws_lambda_function.portfolio_counter.function_name
  authorization_type    = "NONE"
  cors {
    allow_credentials = true
    allow_origins     = var.allowed_origins
    allow_methods     = ["GET", "POST"]
    allow_headers     = ["Content-Type"]
    expose_headers    = ["Content-Length"]
    max_age           = 86400
  }

  depends_on = [aws_lambda_function.portfolio_counter]
}
