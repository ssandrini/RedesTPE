variable "account_id" {
  type        = string
  description = "Current account ID"
}

variable "index_document" {
  description = "Index for website"
  type        = string
  default     = "index.html"
}

variable "sse_algorithm" {
  description = "Algorithm used for server side encryption"
  type        = string
  default     = "AES256"
}