module "ssm_param" {
  providers = {
    aws = aws.parameters
  }

  source = "../../modules/ssm-param-output"

  params = [
    {
      name        = "/eks/base/arn"
      value       = module.base_eks.eks_arn
      description = "EKS cluster for base-infra"
    },
    {
      name        = "/eks/base/endpoint"
      value       = module.base_eks.eks_endpoint
      description = "EKS cluster endpoint for base-infra"
    },
    {
      name        = "/eks/base/id"
      value       = module.base_eks.eks_cluster_id
      description = "EKS cluster ID for base-infra"
    }
  ]
}