module "ssm_param" {
  providers = {
    aws = aws.parameters
  }

  source = "../../modules/ssm-param-output"

  params = [
    {
      name        = "/s3/base/arn"
      value       = module.base_s3_bucket.bucket_arn
      description = "S3 bucket for Base Infra"
    }
  ]
}