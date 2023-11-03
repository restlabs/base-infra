module "ssm_param" {
  providers = {
    aws = aws.parameters
  }

  source = "../../modules/ssm-param-output"

  params = [
    {
      name        = "/eks/base/arn"
      value       = module.base_eks.cluster_arn
      description = "EKS cluster for base-infra"
    },
    {
      name        = "/eks/base/endpoint"
      value       = module.base_eks.cluster_endpoint
      description = "EKS cluster endpoint for base-infra"
    },
    {
      name        = "/eks/base/id"
      value       = module.base_eks.cluster_name
      description = "EKS cluster ID for base-infra"
    },
    {
      name        = "/eks/oidc/provider/arn"
      value       = module.base_eks.oidc_provider_arn
      description = "EKS oidc provider arn"
    }
  ]

  tags = local.base_tags
}
