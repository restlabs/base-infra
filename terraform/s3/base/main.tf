module "base_s3_bucket" {
  source           = "../../modules/s3"
  app_name         = var.app_name
  block_public_acl = true
  code_location    = "terraform/s3/base"
  email            = var.email
  owner            = var.owner
  region           = var.region
  environment      = data.aws_ssm_parameter.account_env.value
  project          = "base-infra"
}
