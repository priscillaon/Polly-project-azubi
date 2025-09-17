variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "s3_audio_bucket" {
  description = "Bucket name where audio files will be stored"
  type        = string
}

variable "handler" {
  description = "Lambda handler function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "platform" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.11"
}

variable "sourcepath" {
  description = "Path to Lambda deployment package (zip file)"
  type        = string
}

variable "environmnt" {
  description = "Environment variables to set for the Lambda function"
  type        = map(string)
  default     = {}
}