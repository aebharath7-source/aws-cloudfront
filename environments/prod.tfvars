aws_region         = "us-east-1"
environment        = "prod"
origin_bucket_name = "my-cloudfront-origin-prod-bucket"

enabled         = true
is_ipv6_enabled = true
comment         = "Production CloudFront Distribution"

default_root_object = "index.html"
aliases             = []  # Add your custom domains here, e.g., ["cdn.example.com"]

price_class  = "PriceClass_All"
http_version = "http2and3"

default_cache_behavior = {
  allowed_methods        = ["GET", "HEAD", "OPTIONS"]
  cached_methods         = ["GET", "HEAD"]
  viewer_protocol_policy = "redirect-to-https"
  compress               = true
  query_string           = false
  cookies_forward        = "none"
  min_ttl                = 0
  default_ttl            = 86400
  max_ttl                = 31536000
}

geo_restriction_type      = "none"
geo_restriction_locations = []

# Add your ACM certificate ARN for custom domain SSL
acm_certificate_arn      = null  # e.g., "arn:aws:acm:us-east-1:123456789012:certificate/xxxxx"
minimum_protocol_version = "TLSv1.2_2021"
