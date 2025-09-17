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

locals {
  website_files = fileset("${path.module}/website", "**")
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.static_site.id
  key    = "index.html"
  content = templatefile("${path.module}/website/index.html.tmpl", {
    api_base_url = "${var.api_base_url}/tts"
  })
  content_type = "text/html"
}

resource "aws_s3_bucket_public_access_block" "static_site" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "website_files" {
  for_each = { for f in local.website_files : f => f if f != "index.html.tmpl" }

  bucket = aws_s3_bucket.static_site.id
  key    = each.value
  source = "${path.module}/website/${each.value}"

  content_type = lookup({
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
  }, regex("\\.([^.]+)$", each.value)[0], "application/octet-stream")
}