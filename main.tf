# Create S3 bucket for CloudFront origin
resource "aws_s3_bucket" "cloudfront_origin" {
  bucket = var.origin_bucket_name
  
  tags = {
    Name        = var.origin_bucket_name
    Environment = var.environment
  }
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "cloudfront_origin_versioning" {
  bucket = aws_s3_bucket.cloudfront_origin.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudfront_origin_encryption" {
  bucket = aws_s3_bucket.cloudfront_origin.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.environment}-s3-oac"
  description                       = "OAC for S3 bucket ${var.origin_bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "main" {
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  default_root_object = var.default_root_object
  aliases             = var.aliases
  price_class         = var.price_class
  http_version        = var.http_version

  origin {
    domain_name              = aws_s3_bucket.cloudfront_origin.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.cloudfront_origin.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  default_cache_behavior {
    allowed_methods        = var.default_cache_behavior.allowed_methods
    cached_methods         = var.default_cache_behavior.cached_methods
    target_origin_id       = "S3-${aws_s3_bucket.cloudfront_origin.id}"
    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    compress               = var.default_cache_behavior.compress

    forwarded_values {
      query_string = var.default_cache_behavior.query_string

      cookies {
        forward = var.default_cache_behavior.cookies_forward
      }
    }

    min_ttl     = var.default_cache_behavior.min_ttl
    default_ttl = var.default_cache_behavior.default_ttl
    max_ttl     = var.default_cache_behavior.max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null ? true : false
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = var.minimum_protocol_version
  }

  tags = {
    Name        = "${var.environment}-cloudfront"
    Environment = var.environment
  }
}

# S3 Bucket Policy to allow CloudFront OAC
resource "aws_s3_bucket_policy" "cloudfront_origin_policy" {
  bucket = aws_s3_bucket.cloudfront_origin.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.cloudfront_origin.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.main.arn
          }
        }
      }
    ]
  })
}
