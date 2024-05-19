data "aws_iam_policy_document" "frontend_OAI_policy" {
  statement {
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_OAI.iam_arn]
    }
    resources = [var.bucket_arn, "${var.bucket_arn}/*"]
  }
}

data "aws_cloudfront_cache_policy" "optimized_policy" {
  name = "Managed-CachingOptimized"
}