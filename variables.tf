variable "bucket_name" {
  description = "Name of the bucket that contains website"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token used to create records in selected zone"
  type        = string
}

variable "cloudfront_functions" {
  description = "Cloudfront function to attach to distribution"
  type        = map
  default = {}
}

variable "custom_domain" {
    description = "Domain that will point to CloudFront distribution in custom_domain_zone"
    type = string
}

variable "custom_domain_zone" {
    description = "Cloudflare zone where records will be created"
    type = string
}

variable "default_root_object" {
    description = "Default path of CloudFront distribution"
    type = string
    default = "index.html"
}

variable "distribution_comment" {
    description = "Description of the CloudFront distribution"
    type = string
}

variable "key_id" {
    description = "Key use to encrypt bucket"
    type = string
}

variable "profile" {
  description = "Profile to use for the provider"
  type        = string
}

variable "region" {
  description = "Deployment region"
  type        = string
}

