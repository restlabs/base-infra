module "ssm_param" {
  providers = {
    aws = aws.parameters
  }

  source = "../../modules/ssm-param-output"

  params = [
    {
      name        = "/vpc/base/id"
      value       = module.base_vpc.vpc_id
      description = "Base Infra VPC ID"
    },
    {
      name        = "/vpc/base/arn"
      value       = module.base_vpc.vpc_arn
      description = "Base Infra VPC arn"
    }
  ]

  tags = local.common_tags
}
