locals {
  base_tags = {
    owner         = var.owner
    code_location = "terraform/s3/base"
    project       = "base-infra"
    email         = var.email
  }
}

module "terraform_aws_version" {
  source = "../../modules/terraform_version"
}

terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region[terraform.workspace]

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
