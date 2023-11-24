module "test_base_vpc" {
  source      = "../../vpc"
  app_name    = var.app_name
  cidr_block  = "10.10.0.0/16"
  email       = var.email
  owner       = var.owner
  region      = var.region
  environment = data.aws_ssm_parameter.account_env.value
  project     = local.base_tags.project
  tags        = local.base_tags
}