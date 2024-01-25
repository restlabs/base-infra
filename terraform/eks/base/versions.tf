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

  use_localstack = (terraform.workspace == "ci-test")

  aws_settings = (
    local.use_localstack ?
    {
      skip_credentials_validation = true
      skip_metadata_api_check     = true
      skip_requesting_account_id  = true

      override_endpoint = "http://localhost:4566"
    } :
    {
      skip_credentials_validation = null
      skip_metadata_api_check     = null
      skip_requesting_account_id  = null

      override_endpoint = null
    }
  )
}

module "terraform_aws_version" {
  source = "../../modules/terraform-aws-version"
}

terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region

  skip_credentials_validation = local.aws_settings.skip_credentials_validation
  skip_metadata_api_check     = local.aws_settings.skip_metadata_api_check
  skip_requesting_account_id  = local.aws_settings.skip_requesting_account_id

  dynamic "endpoints" {
    for_each = local.aws_settings.override_endpoint[*]
    content {
      ec2 = endpoints.value
      iam = endpoints.value
    }
  }

  default_tags {
    tags = local.base_tags
  }
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
}

