# variables.tf

variable "bucket_name" {
  description = "The name for the S3 bucket where audio files will be stored."
  type        = string
}

variable "environment" {
  description = "The environment name for tagging resources."
  type        = string
}