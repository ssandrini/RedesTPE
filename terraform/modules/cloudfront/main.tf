resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = var.bucket_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_OAI.cloudfront_access_identity_path
    }
  }

  aliases = var.aliases

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.certificate_arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  web_acl_id = var.waf_arn
}

resource "aws_cloudfront_origin_access_identity" "cloudfront_OAI" {
  comment = "OAI"
}

resource "aws_s3_bucket_policy" "OAI_policy" {
  bucket = var.bucket_origin_id
  policy = data.aws_iam_policy_document.frontend_OAI_policy.json
}