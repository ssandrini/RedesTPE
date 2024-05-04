variable "base_cidr_block" {
  description = "The base CIDR block for subnet calculations."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_configs" {
  description = "Description of the subnets that exist within the VPC."
  type = list(object({
    subnet_bits       = number
    availability_zone = string
    name              = string
    map_public_ip_on_launch = bool
  }))
  default = [
    {
      subnet_bits       = 8
      availability_zone = "us-east-1a"
      name              = "redes-tpe-subnet-1a-elb"
      map_public_ip_on_launch = true           
    },
    {
      subnet_bits       = 8
      availability_zone = "us-east-1b"
      name              = "redes-tpe-subnet-1b-elb"
      map_public_ip_on_launch = true           
    }, 
    {
      subnet_bits       = 8
      availability_zone = "us-east-1b"
      name              = "redes-tpe-subnet-1b-ec2"
      map_public_ip_on_launch = false           
    }
  ]
}

variable "user_data" {
  default = "user_data.sh"
}