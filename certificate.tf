resource "aws_acm_certificate" "certificate" {
  provider = aws.us-east-1

  domain_name = "${var.custom_domain}.${data.cloudflare_zone.domain_zone.name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_acm_certificate_validation" "certificate_validation" {
  provider        = aws.us-east-1
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in cloudflare_record.certificate_validation_records : record.hostname]
}

resource "cloudflare_record" "certificate_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id = data.cloudflare_zone.domain_zone.id
  name    = each.value.name
  value   = each.value.record
  type    = each.value.type
  ttl     = 60
}
