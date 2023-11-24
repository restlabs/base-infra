module "test_base_igw" {
  source      = "../../internet-gateway"
  app_name    = local.base_tags.project
  email       = var.email
  environment = data.aws_ssm_parameter.account_env.value
  owner       = var.owner
  project     = local.base_tags.project
  region      = var.region
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  tags        = local.base_tags
}