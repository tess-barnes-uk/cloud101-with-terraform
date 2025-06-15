variable "owner" {
  type        = string
  description = "Ensures appropriate sandbox tagging, this should be your name. There is no default"
}

variable "s3_bucket_name" {
  type = string
}
