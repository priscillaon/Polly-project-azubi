resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for static site bucket access"
}

resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = var.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontRead"
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${var.bucket_arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "s3_cdn" {
  enabled             = true
  default_root_object = var.default_root_object

  origin {
    domain_name = var.bucket_rest_domain_name
    origin_id   = "s3-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? "sni-only" : null
  }
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.s3_cdn.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_cdn.id
}