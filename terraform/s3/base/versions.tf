module "terraform_aws_version" {
  source = "../../modules/terraform_version"
}

provider "aws" {
  region = var.region[terraform.workspace]
}

provider "aws" {
  alias = "parameters"
}
