output "cloudfront_distribution" {
  description = "Cloudfront distribution for deployment"
  value       = aws_cloudfront_distribution.s3_distribution
}

output "cloudfront_OAI" {
  description = "OAI for S3"
  value       = aws_cloudfront_origin_access_identity.cloudfront_OAI.iam_arn
}