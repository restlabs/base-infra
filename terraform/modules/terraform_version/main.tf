terraform {
  backend "s3" {}
  required_version = ">= 1.5.7"
  require_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}
