output "cloudfront_domain" {
  value = module.cloudfront.cloudfront_domain
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.cloudfront_distribution_id
}

output "api_invoke_url" {
  value = module.api_gateway.invoke_url
}

output "s3_bucket_name" {
  value = module.s3_web.static_site_bucket_name
}

output "s3_bucket_url" {
  value = module.s3_web.static_site_bucket_regional_domain_name
}