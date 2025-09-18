variable "bucket_name" {
  description = "Name of the S3 bucket for hosting the static website"
  type        = string
}

variable "api_base_url" {
  description = "Base URL of the API Gateway (without path)"
  type        = string
}