# Get the hosted zone for the domain
data "aws_route53_zone" "main" {
  name = var.domain_name
}

locals {
  cloudfront_zone_id = "Z2FDTNDATAQYW2"
}

# Root domain A record (alias to CloudFront)
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# Root domain AAAA record (alias to CloudFront for IPv6)
resource "aws_route53_record" "root_ipv6" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}
