output "certificate_arn" {
  description = "Certificate amazon resource number"
  value       = aws_acm_certificate.acm_certificate.arn
}