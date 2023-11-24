locals {
  base_tags = {
    # keep Name key capitalized so that it will be set in the resource name!
    Name          = var.app_name
    branch        = var.branch
    code_location = "terraform/vpc/base"
    commit        = var.commit
    email         = var.email
    environment   = data.aws_ssm_parameter.account_env.value
    owner         = var.owner
    project       = "base-infra"
  }
}

module "terraform_aws_version" {
  source = "../../../modules/terraform-aws-version"
}

provider "aws" {
  region = "us-east-2"

  endpoints {
    s3 = "http://s3.localhost.localstack.cloud:4566"
  }

  default_tags {
    tags = local.base_tags
  }
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
}

