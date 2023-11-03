locals {
  cluster_name         = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  karpenter_chart      = "karpenter"
  karpenter_version    = "v0.32.1"
  karpenter_namespace  = "karpenter"
  karpenter_repository = "oci://public.ecr.aws/karpenter/karpenter"
}

module "karpenter" {
  source        = "../../modules/helm-install"
  chart         = local.karpenter_chart
  chart_version = local.karpenter_version
  namespace     = local.karpenter_namespace
  release_name  = local.karpenter_chart
  repository    = local.karpenter_repository
  values_map    = {}
}