resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name
}
 
resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.id
 
  index_document {
    suffix = "index.html"
  }
 
  error_document {
    key = "error.html"
  }
}
 
resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.static_site.id
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.static_site.arn}/*"
    }]
  })
}
 
output "static_site_bucket_name" {
  value = aws_s3_bucket.static_site.id
}
 
output "static_site_endpoint" {
  value = aws_s3_bucket_website_configuration.static_site.website_endpoint
}