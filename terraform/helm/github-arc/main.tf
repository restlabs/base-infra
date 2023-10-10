locals {
  cluster_name  = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  chart         = "gha-runner-scale-set-controller"
  chart_version = "0.6.1"
  namespace     = "actions-runner-controller"
  repository    = "oci://ghcr.io/actions/actions-runner-controller-charts"
}

module "arc" {
  source        = "../../modules/helm-install"
  chart         = local.chart
  chart_version = local.chart_version
  namespace     = local.namespace
  release_name  = local.namespace
  repository    = local.repository
  values_map    = {}
}
