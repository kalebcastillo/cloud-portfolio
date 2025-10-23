variable "domain_name" {
  description = "Domain name for the certificate"
  type        = string
}

variable "create_certificate" {
  description = "Whether to create the certificate"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
