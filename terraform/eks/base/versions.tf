module "terraform_aws_version" {
  source = "../../modules/terraform-aws-version"
}

terraform {
  backend "s3" {}
}

locals {
  base_tags = {
    branch        = var.branch
    code_location = "terraform/eks/base"
    commit        = var.commit
    owner         = var.owner
    project       = "base-infra"
    email         = var.email
    environment   = data.aws_ssm_parameter.account_env.value
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
}

