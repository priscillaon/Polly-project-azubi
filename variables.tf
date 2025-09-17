variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "bucket_name" {
  type = string
  description = "arn:aws:s3:::text-to-speechbucketproj"
}

variable "api_url" {
  type = string
  description = "https://kienvzrr0k.execute-api.us-east-2.amazonaws.com/polly-proj"
}
