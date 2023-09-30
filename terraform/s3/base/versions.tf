module "terraform_aws_version" {
  source = "../../modules/terraform_version"
}

terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region[terraform.workspace]
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
}
