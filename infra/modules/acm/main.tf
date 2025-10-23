# Request an SSL/TLS certificate from AWS Certificate Manager
resource "aws_acm_certificate" "website" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(
    var.tags,
    {
      Name = "${var.domain_name}-cert"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Get the Route53 hosted zone for the domain
data "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

# Wait for the certificate to be validated (polling DNS records)
resource "aws_acm_certificate_validation" "website" {
  certificate_arn = aws_acm_certificate.website.arn
  depends_on      = [aws_route53_record.acm_validation]
}
