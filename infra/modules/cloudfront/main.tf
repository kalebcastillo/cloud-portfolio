# Origin Access Control to securely connect CloudFront to S3
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.environment}-${var.project_name}-oac"
  description                       = "OAC for ${var.environment} environment"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# S3 bucket policy to allow only CloudFront OAC to access objects
resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = var.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAC"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${var.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.website.id}"
          }
        }
      }
    ]
  })
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.default_root_object
  price_class         = var.price_class

  # Origin configuration pointing to S3 bucket
  origin {
    domain_name              = "${var.s3_bucket_id}.s3.${var.s3_bucket_region}.amazonaws.com"
    origin_id                = "s3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  # Default cache behavior for all requests
  default_cache_behavior {
    cache_policy_id            = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.managed_all_viewer.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.managed_security_headers.id
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    viewer_protocol_policy     = "redirect-to-https"
    target_origin_id           = "s3Origin"
  }

  # Cache behavior for index.html with shorter TTL for quick updates
  ordered_cache_behavior {
    path_pattern               = "index.html"
    cache_policy_id            = data.aws_cloudfront_cache_policy.managed_caching_disabled.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.managed_all_viewer.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.managed_security_headers.id
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    viewer_protocol_policy     = "redirect-to-https"
    target_origin_id           = "s3Origin"
  }

  # Restrictions for geo-blocking (allowing all countries)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Viewer certificate using CloudFront default certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.project_name}-distribution"
    }
  )
}

# Get AWS account ID for the bucket policy
data "aws_caller_identity" "current" {}

# Get managed cache policy for optimized caching
data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}

# Get managed cache policy for no caching (for index.html)
data "aws_cloudfront_cache_policy" "managed_caching_disabled" {
  name = "Managed-CachingDisabled"
}

# Get managed origin request policy for all viewer headers
data "aws_cloudfront_origin_request_policy" "managed_all_viewer" {
  name = "Managed-AllViewerExceptHostHeader"
}

# Get managed response headers policy for security headers
data "aws_cloudfront_response_headers_policy" "managed_security_headers" {
  name = "Managed-SecurityHeadersPolicy"
}
