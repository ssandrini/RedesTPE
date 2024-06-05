module "vpc" {
  source = "../modules/vpc"
}

module "api" {
  source      = "../modules/api"
  user_data   = "../resources/user_data.sh"
  main_vpc_id = module.vpc.main_vpc_id
  subnets_ids = module.vpc.subnet_ids
}

# FAILOVER MODULES

module "vpc_failover" {
  source = "../modules/vpc"
  providers = {
    aws = aws.secondary
  }
  subnet_configs = [
    {
      subnet_bits             = 8
      availability_zone       = "us-west-2a"
      name                    = "redes-tpe-subnet-1a-public-elb"
      map_public_ip_on_launch = true
    },
    {
      subnet_bits             = 8
      availability_zone       = "us-west-2b"
      name                    = "redes-tpe-subnet-1b-public-elb"
      map_public_ip_on_launch = true
    },
    {
      subnet_bits             = 8
      availability_zone       = "us-west-2b"
      name                    = "redes-tpe-subnet-1b-private-ec2"
      map_public_ip_on_launch = false
    },
    {
      subnet_bits             = 8
      availability_zone       = "us-west-2a"
      name                    = "redes-tpe-subnet-1a-private-ec2"
      map_public_ip_on_launch = false
    }
  ]
}

module "api_failover" {
  providers = {
    aws = aws.secondary
  }
  source      = "../modules/api"
  user_data   = "../resources/user_data.sh"
  main_vpc_id = module.vpc_failover.main_vpc_id
  subnets_ids = module.vpc_failover.subnet_ids
  instance_id = "ami-0eb9d67c52f5c80e5"
}


# Static website hosting (using R53 + CDN + S3)

module "route53" {
  source                      = "../modules/route53"
  domain_name                 = var.domain_name
  cdn                         = module.cloudfront.cloudfront_distribution
  depends_on                  = [module.cloudfront]
  alb_domain_name             = module.api.api_domain_name
  secondary_alb_domain_name   = module.api_failover.api_domain_name
  on_premise_load_balancer_ip = "192.168.56.40"
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