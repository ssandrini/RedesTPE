output "website_endpoint" {
  value = module.frontend_bucket.s3_bucket_website_endpoint
}

output "frontend_bucket_id" {
  value = module.frontend_bucket.s3_bucket_id
}

output "frontend_bucket_rdn" {
  description = "frontend bucket regional domain name"
  value       = module.frontend_bucket.s3_bucket_bucket_regional_domain_name
}

output "redirect_bucket_rdn" {
  description = "frontend bucket regional domain name"
  value       = module.redirect_bucket.s3_bucket_bucket_regional_domain_name
}

output "frontend_bucket_arn" {
  description = "frontend bucket ARN"
  value       = module.frontend_bucket.s3_bucket_arn
}