module "terraform_aws_version" {
  source = "../../modules/terraform_version"
}

terraform {
  backend "s3" {}
}

locals {
  base_tags = {
    owner         = var.owner
    code_location = "terraform/eks/base"
    project       = "base-infra"
    email         = var.email
    environment   = var.environment
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = local.base_tags
  }
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
  default_tags {
    tags = local.base_tags
  }
}

