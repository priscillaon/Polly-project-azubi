resource "aws_s3_bucket" "audio_files" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = "audio-files"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "audio_files" {
  bucket = aws_s3_bucket.audio_files.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "audio_files" {
  bucket = aws_s3_bucket.audio_files.id

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    allowed_headers = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "audio_files" {
  bucket = aws_s3_bucket.audio_files.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "audio_bucket_name" {
  value = aws_s3_bucket.audio_files.bucket
}

output "audio_bucket_arn" {
  value = aws_s3_bucket.audio_files.arn
}

