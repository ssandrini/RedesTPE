variable "user_data" {
  default = "user_data.sh"
}

variable "main_vpc_id" {
  description = "main vpc ID"
  type        = string
}

variable "subnets_ids" {
  type = list(any)
}