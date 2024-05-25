output "api_domain_name" {
    value = aws_lb.lb.dns_name
}