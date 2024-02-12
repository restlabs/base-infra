locals {
  base_tags = {
    branch        = var.branch
    code_location = "terraform/lambda/hello-world"
    commit        = var.commit
    email         = var.email
    environment   = data.aws_ssm_parameter.account_env.value
    owner         = var.owner
    project       = var.app_name
  }
}

module "terraform_aws_version" {
  source = "../../modules/terraform-aws-version"
}

terraform {
  backend "s3" {}
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
}
