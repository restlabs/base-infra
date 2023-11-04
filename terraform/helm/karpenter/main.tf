locals {
  cluster_name          = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  karpenter_chart       = "karpenter"
  karpenter_version     = "v0.32.1"
  karpenter_namespace   = "karpenter"
  karpenter_repository  = "oci://public.ecr.aws/karpenter"
  karpenter_annotations = "com/role-arn"

  values_map = {
    serviceAccount = {
      annotations = {
        tostring("eks.amazonaws.com/role-arn") = aws_iam_role.karpenter_role.arn
      }
    }

    settings = {
      clusterName       = data.aws_ssm_parameter.eks_cluster_name.value
      clusterEndpoint   = data.aws_ssm_parameter.eks_cluster_endpoint.value
      interruptionQueue = data.aws_ssm_parameter.eks_cluster_name.value
    }
  }
}

module "karpenter" {
  source        = "../../modules/helm-install"
  chart         = local.karpenter_chart
  chart_version = local.karpenter_version
  namespace     = local.karpenter_namespace
  release_name  = local.karpenter_chart
  repository    = local.karpenter_repository
  values_map    = local.values_map
}