resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "certs_records" {
  for_each = {
    for domain_validation_object in aws_acm_certificate.acm_certificate.domain_validation_options : domain_validation_object.domain_name => {
      name   = domain_validation_object.resource_record_name
      record = domain_validation_object.resource_record_value
      type   = domain_validation_object.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.prebuilt_hosted_zone.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certs_records : record.fqdn]
}