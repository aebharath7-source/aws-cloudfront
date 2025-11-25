aws_region         = "us-east-1"
environment        = "uat"
origin_bucket_name = "my-cloudfront-origin-uat-bucket"

enabled         = true
is_ipv6_enabled = true
comment         = "UAT CloudFront Distribution"

default_root_object = "index.html"
aliases             = []

price_class  = "PriceClass_200"
http_version = "http2"

default_cache_behavior = {
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

geo_restriction_type      = "none"
geo_restriction_locations = []

acm_certificate_arn      = null
minimum_protocol_version = "TLSv1.2_2021"
