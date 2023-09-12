module "base_s3_bucket" {
  source        = "../../modules/s3"
  app_name      = var.app_name
  code_location = "terraform/s3"
  email         = var.email
  owner         = var.owner
  region        = var.region[terraform.workspace]
  environment   = data.aws_ssm_parameter.account_env.value
}