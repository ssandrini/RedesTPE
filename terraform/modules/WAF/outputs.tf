output "waf_acl_arn" {
  description = "ARN of the created WAF ACL"
  value       = aws_wafv2_web_acl.waf-rate-acl.arn
}
