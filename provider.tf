terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  profile = var.profile

  default_tags {
    tags = {
      From      = "Infra"
      Terraform = "static-website"
    }
  }
}

provider "aws" {
  alias = "main"
  region = "eu-north-1"

  profile = "main"

  default_tags {
    tags = {
      From      = "Infra"
      Terraform = "static-website"
    }
  }
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"

  profile = var.profile

  default_tags {
    tags = {
      From      = "Infra"
      Terraform = "static-website"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

