locals {
  cluster_name        = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  base_infra_repo_url = "https://github.com/pafable/base-infra"
  chart               = "argo-cd"
  chart_version       = "5.46.7"
  namespace           = "argo"
  repository          = "https://argoproj.github.io/argo-helm"

  base_infra_repo = {
    name = local.base_tags.project
    url  = local.base_infra_repo_url
  }

  test_repo = {
    name = "test-repo"
    url  = "https://test-repo.local"
  }

  values_map = {
    applicationSet = {
      replicaCount = 2
    }

    configs = {
      repositories = {
        base-infra = local.base_infra_repo
        test-repo  = local.test_repo
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
        enabled     = true
        minReplicas = 2
      }
    }

    server = {
      autoscaling = {
        enabled     = true
        minReplicas = 2
      }
    }
  }
}

module "argo" {
  source        = "../../modules/helm-install"
  chart         = local.chart
  chart_version = local.chart_version
  namespace     = local.namespace
  release_name  = local.namespace
  repository    = local.repository
  values_map    = local.values_map
}
