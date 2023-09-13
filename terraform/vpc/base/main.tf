module "base_vpc_bucket" {
  source        = "../../modules/vpc"
  app_name      = var.app_name
  cidr_block    = "10.10.0.0/16"
  code_location = "terraform/vpc/base"
  email         = var.email
  owner         = var.owner
  region        = var.region
  environment   = data.aws_ssm_parameter.account_env.value
  project       = "base-infra"
}