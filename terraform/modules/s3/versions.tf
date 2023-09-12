terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  common_tags = {
    name  = var.app_name
    email = var.email
    owner = var.owner
    env   = var.environment
  }
}

provider "aws" {
  default_tags {
    tags = local.common_tags
  }
  region = var.region
}
