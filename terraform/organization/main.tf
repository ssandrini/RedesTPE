module "vpc" {
  source = "../modules/vpc"
}

module "api" {
  source      = "../modules/api"
  user_data   = "../resources/user_data.sh"
  main_vpc_id = module.vpc.main_vpc_id
  subnets_ids = module.vpc.subnet_ids
}


# Static website hosting (using R53 + CDN + S3)

module "route53" {
  source      = "../modules/route53"
  domain_name = var.domain_name
  cdn         = module.cloudfront.cloudfront_distribution
  depends_on  = [module.cloudfront]
}

module "S3" {
  source     = "../modules/S3"
  account_id = data.aws_caller_identity.this.account_id
}

module "cloudfront" {
  source                      = "../modules/cloudfront"
  domain_name                 = var.domain_name
  certificate_arn             = module.acm.certificate_arn
  bucket_origin_id            = module.S3.frontend_bucket_id
  bucket_regional_domain_name = module.S3.frontend_bucket_rdn
  bucket_arn                  = module.S3.frontend_bucket_arn
  aliases                     = [var.subdomain_www, var.domain_name]
  waf_arn                     = module.WAF.waf_acl_arn
  depends_on                  = [module.acm, module.WAF]
}

module "WAF" {
  source = "../modules/WAF"
}

module "acm" {
  source      = "../modules/acm"
  domain_name = var.domain_name
}