module "terraform_aws_version" {
  source = "../terraform_version"
}

locals {
  cluster_name = "${var.owner}-${var.environment}-eks-${var.region}"
  base_tags = {
    owner         = var.owner
    code_location = var.code_location
    project       = var.project
    email         = var.email
    environment   = var.environment
  }
}

provider "aws" {
  default_tags {
    tags = local.base_tags
  }
  region = var.region
}
