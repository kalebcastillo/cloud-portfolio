output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = data.aws_route53_zone.main.zone_id
}

output "nameservers" {
  description = "Route53 nameservers for external registrar configuration"
  value       = data.aws_route53_zone.main.name_servers
}

output "root_domain_fqdn" {
  description = "Fully qualified domain name for root domain"
  value       = aws_route53_record.root.fqdn
}

output "root_record_id" {
  description = "Route53 record ID for root domain"
  value       = aws_route53_record.root.id
}
