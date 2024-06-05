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

resource "aws_route53_record" "cname_route53_record" {
  zone_id = data.aws_route53_zone.prebuilt_hosted_zone.zone_id
  name    = "api.${var.domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [var.alb_domain_name]
  failover_routing_policy {
    type = "PRIMARY"
  }
  set_identifier = "primary_alb"
  health_check_id = aws_route53_health_check.primary.id
}

resource "aws_route53_record" "failover_cname_route53_record" {
  zone_id = data.aws_route53_zone.prebuilt_hosted_zone.zone_id
  name    = "api.${var.domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [var.secondary_alb_domain_name]
  failover_routing_policy {
    type = "SECONDARY"
  }
  set_identifier = "secondary_alb"
  health_check_id = aws_route53_health_check.secondary.id
}

resource "aws_route53_health_check" "primary" {
  fqdn              = var.alb_domain_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "1"
  request_interval  = "15"

  tags = {
    Name = "route53-primary-health-check"
  }
}

resource "aws_route53_health_check" "secondary" {
  fqdn              = var.secondary_alb_domain_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "1"
  request_interval  = "15"

  tags = {
    Name = "route53-secondary-health-check"
  }
}