data "aws_kms_key" "encryption_key" {
  provider = aws.main
  key_id   = var.key_id
}

data "cloudflare_zone" "domain_zone" {
  name = var.custom_domain_zone
}

data "aws_cloudfront_cache_policy" "cf_cache_policy" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "cf_origin_policy" {
  name = "Managed-CORS-S3Origin"
}

data "aws_cloudfront_response_headers_policy" "cf_response_policy" {
  name = "Managed-SecurityHeadersPolicy"
}
