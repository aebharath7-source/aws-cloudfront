variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
}

variable "origin_bucket_name" {
  description = "Name of the S3 bucket to use as CloudFront origin"
  type        = string
}

variable "enabled" {
  description = "Whether the CloudFront distribution is enabled"
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether IPv6 is enabled for the distribution"
  type        = bool
  default     = true
}

variable "comment" {
  description = "Comment for the CloudFront distribution"
  type        = string
  default     = "Managed by Terraform"
}

variable "default_root_object" {
  description = "Object that CloudFront returns when requesting root URL"
  type        = string
  default     = "index.html"
}

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names) for this distribution"
  type        = list(string)
  default     = []
}

variable "price_class" {
  description = "Price class for CloudFront distribution"
  type        = string
  default     = "PriceClass_100"
}

variable "http_version" {
  description = "Maximum HTTP version to support"
  type        = string
  default     = "http2"
}

variable "default_cache_behavior" {
  description = "Default cache behavior configuration"
  type = object({
    allowed_methods        = list(string)
    cached_methods         = list(string)
    viewer_protocol_policy = string
    compress               = bool
    query_string           = bool
    cookies_forward        = string
    min_ttl                = number
    default_ttl            = number
    max_ttl                = number
  })
  default = {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    query_string           = false
    cookies_forward        = "none"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
}

variable "geo_restriction_type" {
  description = "Method to restrict distribution (whitelist, blacklist, none)"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "ISO 3166-1-alpha-2 country codes for geo restriction"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for custom domain (optional)"
  type        = string
  default     = null
}

variable "minimum_protocol_version" {
  description = "Minimum SSL/TLS protocol version"
  type        = string
  default     = "TLSv1.2_2021"
}
