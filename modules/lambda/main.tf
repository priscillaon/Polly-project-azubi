resource "aws_iam_role" "lambda_tts_project" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.lambda_function_name}-policy"
  role = aws_iam_role.lambda_tts_project.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_audio_bucket}",
          "arn:aws:s3:::${var.s3_audio_bucket}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "polly:SynthesizeSpeech"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_lambda_function" "polly_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_tts_project.arn
  handler       = "polly_lambda.lambda_handler"
  runtime       = var.runtime
  filename      = "${path.module}/lambda-polly.zip"
  timeout       = 15

  source_code_hash = filebase64sha256("${path.module}/lambda-polly.zip")

  environment {
    variables = {
      AUDIO_BUCKET = var.s3_audio_bucket
    }
  }
}