output "static_site_bucket_name" {
  value = aws_s3_bucket.static_site.bucket
}

output "static_site_endpoint" {
  value = aws_s3_bucket.static_site.website_endpoint
}

output "static_site_bucket_arn" {
  value = aws_s3_bucket.static_site.arn
}

output "static_site_bucket_regional_domain_name" {
  value = aws_s3_bucket.static_site.bucket_regional_domain_name
}