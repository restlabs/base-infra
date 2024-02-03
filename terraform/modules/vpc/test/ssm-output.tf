module "ssm_param" {
  providers = {
    aws = aws.parameters
  }

  source = "../../../modules/ssm-param-output"

  params = [
    {
      name        = "/vpc/base/id"
      value       = module.test_base_vpc.vpc_id
      description = "Test Base Infra VPC ID"
    },
    {
      name        = "/vpc/base/arn"
      value       = module.test_base_vpc.vpc_arn
      description = "Test Base Infra VPC arn"
    }
  ]

  tags = local.base_tags
}
