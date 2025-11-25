output "cloudfront_distribution_id" {
  description = "The identifier for the distribution"
  value       = aws_cloudfront_distribution.main.id
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the distribution"
  value       = aws_cloudfront_distribution.main.arn
}

output "cloudfront_domain_name" {
  description = "The domain name of the distribution"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront Route 53 zone ID"
  value       = aws_cloudfront_distribution.main.hosted_zone_id
}

output "cloudfront_status" {
  description = "Current status of the distribution"
  value       = aws_cloudfront_distribution.main.status
}

output "s3_bucket_name" {
  description = "Name of the S3 origin bucket"
  value       = aws_s3_bucket.cloudfront_origin.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 origin bucket"
  value       = aws_s3_bucket.cloudfront_origin.arn
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.cloudfront_origin.bucket_regional_domain_name
}

output "origin_access_control_id" {
  description = "ID of the Origin Access Control"
  value       = aws_cloudfront_origin_access_control.s3_oac.id
}
