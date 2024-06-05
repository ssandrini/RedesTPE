variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "cdn" {
  description = "The cloudfront distribution for the primary deployment"
}

variable "alb_domain_name" {
  type = string
}

variable "secondary_alb_domain_name" {
  type = string
}

variable "on_premise_load_balancer_ip" {
  type = string
}