module "base_s3_bucket" {
  source           = "../../modules/s3"
  app_name         = var.app_name
  block_public_acl = true
  region           = var.region
  tags             = local.base_tags
}
