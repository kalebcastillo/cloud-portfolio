# Get AWS account ID for the bucket policy
data "aws_caller_identity" "current" {}

# AWS managed policy IDs (region: us-east-1)
locals {
  cache_policy_caching_optimized   = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  cache_policy_caching_disabled    = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  origin_request_policy_all_viewer = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  response_headers_policy_security = "67f7725c-6f97-4210-82d7-5512b31e9d03"
}

# Origin Access Control to securely connect CloudFront to S3
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.environment}-${var.project_name}-oac"
  description                       = "OAC for ${var.environment} environment"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Function for URL rewriting (SPA routing)
resource "aws_cloudfront_function" "url_rewrite" {
  name    = "${var.environment}-${var.project_name}-url-rewrite"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/function.js")
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
    cache_policy_id            = local.cache_policy_caching_optimized
    origin_request_policy_id   = local.origin_request_policy_all_viewer
    response_headers_policy_id = local.response_headers_policy_security
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    viewer_protocol_policy     = "redirect-to-https"
    target_origin_id           = "s3Origin"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.url_rewrite.arn
    }
  }

  # Cache behavior for index.html with shorter TTL for quick updates
  ordered_cache_behavior {
    path_pattern               = "index.html"
    cache_policy_id            = local.cache_policy_caching_disabled
    origin_request_policy_id   = local.origin_request_policy_all_viewer
    response_headers_policy_id = local.response_headers_policy_security
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

  # Viewer certificate
  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Domain aliases for the distribution
  aliases = var.domain_names

  tags = {
    Name = "${var.environment}-${var.project_name}-distribution"
  }
}
