output "certificate_arn" {
  description = "ARN of the ACM certificate (use in CloudFront)"
  value       = aws_acm_certificate.website.arn
}

output "certificate_domain_name" {
  description = "Domain name on the certificate"
  value       = aws_acm_certificate.website.domain_name
}
