locals {
  cluster_name     = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  base_infra_repo  = "https://github.com/pafable/base-infra"
  chart            = "argo-cd"
  chart_version    = "5.46.7"
  namespace        = "argo"
  repository       = "https://argoproj.github.io/argo-helm"

  values_map = {
    applicationSet = {
      replicaCount = 2
    }

    configs = {
      repositories = {
        base-infra = {
          name = local.base_tags.project
          url  = local.base_infra_repo
        }
      }
    }

    controller = {
      replicas = 1
    }

    redis-ha = {
      enabled = true
    }

    repoServer = {
      autoscaling = {
        enabled = true
        minReplicas = 2
      }
    }

    server = {
      autoscaling = {
        enabled = true
        minReplicas = 2
      }
    }
  }
}

module "argo" {
  source           = "../../modules/helm-install"
  chart            = local.chart
  chart_version    = local.chart_version
  namespace        = local.namespace
  release_name     = local.namespace
  repository       = local.repository
  values_map       = local.values_map
}
