module "terraform_aws_version" {
  source = "../../modules/terraform_version"
}

terraform {
  backend "s3" {}
}

locals {
  cluster_name = "${var.owner}-${var.environment}-eks-${var.region}"
  base_tags = {
    owner         = var.owner
    code_location = "terraform/eks/base"
    project       = "base-infra"
    email         = "test@test.test"
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

