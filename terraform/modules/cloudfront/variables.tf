variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "Bucket regional domain name used for cloudfront distribution"
  type        = string
}

variable "bucket_arn" {
  description = "Bucket arn used for bucket policy"
  type        = string
}

variable "bucket_origin_id" {
  description = "Bucket id used for cloudfront distribution"
  type        = string
}

variable "certificate_arn" {
  description = "Certificate ARN"
  type        = string
}

variable "aliases" {
  description = "Alternate domain names"
  type        = set(string)
}

variable "waf_arn" {
  type = string
}