variable "api_name" {
  description = "Name of API gateway"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Invoke ARN of the lambda function"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}