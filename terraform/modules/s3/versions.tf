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
    name          = var.app_name
    code_location = var.code_location
    email         = var.email
    environment   = var.environment
    owner         = var.owner
    project       = var.project
  }
}

provider "aws" {
  default_tags {
    tags = local.common_tags
  }
  region = var.region
}
