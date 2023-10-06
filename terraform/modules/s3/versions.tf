module "terraform_aws_version" {
  source = "../terraform-aws-version"
}

locals {
  common_tags = {
    # keep Name key capitalized so that it will be set in the resource name!
    Name          = var.app_name
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
