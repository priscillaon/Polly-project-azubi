variable "bucket_domain_name" {
  description = "Domain name of the s3 bucket website endpoint"
  type        = string
}

variable "bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

variable "bucket_id" {
  description = "The ID (name) of the S3 bucket"
  type        = string
}

variable "default_root_object" {
  description = "Default object to serve"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Cloudfront price class (100, 200, All)"
  type        = string
  default     = "PriceClass_100"
}

variable "enable_logging" {
  description = "Enable logging for CloudFront"
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "S3 bucket for CloudFront logs"
  type        = string
  default     = null
}

variable "acm_certificate_arn" {
  description = "value"
  type        = string
  default     = null
}

variable "bucket_rest_domain_name" {
  description = "Name of Bucket"
  type        = string
}
