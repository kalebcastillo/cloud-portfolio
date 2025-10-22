output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.website.id
}

output "domain_name" {
  description = "CloudFront distribution domain name (e.g., d123abc.cloudfront.net)"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "origin_access_control_id" {
  description = "Origin Access Control ID for reference"
  value       = aws_cloudfront_origin_access_control.s3_oac.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.website.arn
}
