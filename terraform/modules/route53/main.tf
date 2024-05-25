resource "aws_route53_record" "domain_record" {
  zone_id = data.aws_route53_zone.prebuilt_hosted_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cdn.domain_name
    zone_id                = var.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.prebuilt_hosted_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 900

  records = ["${var.domain_name}"]

  depends_on = [
    aws_route53_record.domain_record
  ]
}