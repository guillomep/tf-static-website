resource "aws_cloudfront_origin_access_control" "cf_oac" {
  name                              = "${terraform.workspace}-oac"
  description                       = "OAC for distribution of ${terraform.workspace}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "distribution" {

  depends_on = [
    aws_acm_certificate_validation.certificate_validation
  ]

  enabled             = true
  comment             = var.distribution_comment
  default_root_object = var.default_root_object
  aliases             = ["${var.custom_domain}.${data.cloudflare_zone.domain_zone.name}"]

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.bucket.bucket
    origin_access_control_id = aws_cloudfront_origin_access_control.cf_oac.id
  }

  default_cache_behavior {
    compress               = true
    target_origin_id       = aws_s3_bucket.bucket.bucket
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id = data.aws_cloudfront_cache_policy.cf_cache_policy.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.cf_origin_policy.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.cf_response_policy.id

    dynamic "function_association" {
      for_each = var.cloudfront_functions
      content {
        event_type   = function_association.value.type
        function_arn = aws_cloudfront_function.cf_functions[function_association.key].arn
      }
    }

  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.certificate.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

}

resource "cloudflare_record" "distribution_cname" {
  zone_id = data.cloudflare_zone.domain_zone.id
  name    = var.custom_domain
  value   = aws_cloudfront_distribution.distribution.domain_name
  type    = "CNAME"
  proxied = false
}

resource "aws_cloudfront_function" "cf_functions" {
  for_each = var.cloudfront_functions
  name    = "${terraform.workspace}-function-${each.value.type}"
  comment    = "${terraform.workspace}-function-${each.value.type}"
  runtime = each.value.runtime
  publish = true
  code = templatefile("${path.module}/${each.value.code_file_path}", each.value.code_tpl_vars)

  lifecycle {
    create_before_destroy = true
  }
}
