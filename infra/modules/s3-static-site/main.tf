# S3 bucket for static website hosting
resource "aws_s3_bucket" "website" {
  bucket = "${var.environment}-${var.project_name}-website"

  tags = {
    Name        = "${var.environment}-${var.project_name}-website"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Enable versioning to track changes
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access (CloudFront OAC will handle access)
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policy to allow CloudFront access
# This will be created later when we add CloudFront module
# For now, the bucket is private
