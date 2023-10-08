locals {
  cluster_name     = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  base_infra_repo  = "https://github.com/pafable/base-infra"
  chart            = "argo-cd"
  chart_version    = "5.46.7"
  create_namespace = true
  namespace        = "argo"
  release_name     = "argo"
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
      }
    }

    repoServer = {
      autoscaling = {
        minReplicas = 2
      }
    }

    server = {
      autoscaling = {
        enabled = true
      }
    }

    server = {
      autoscaling = {
        minReplicas = 2
      }
    }
  }
}

module "argo" {
  source           = "../../modules/helm-install"
  chart            = local.chart
  chart_version    = local.chart_version
  create_namespace = local.create_namespace
  namespace        = local.namespace
  release_name     = local.release_name
  repository       = local.repository
  values_map       = local.values_map
}

#resource "helm_release" "argocd" {
#  chart            = "argo-cd"
#  create_namespace = true
#  name             = "argo"
#  namespace        = "argo"
#  repository       = "https://argoproj.github.io/argo-helm"
#  version          = "5.46.7"

#  values = [
#    yamlencode({
#      applicationSet = {
#        replicaCount = 2
#      }
#
#      configs = {
#        repositories = {
#          base-infra = {
#            name = local.base_tags.project
#            url  = local.base_infra_repo
#          }
#        }
#      }
#
#      controller = {
#        replicas = 1
#      }
#
#      redis-ha = {
#        enabled = true
#      }
#
#      repoServer = {
#        autoscaling = {
#          enabled = true
#        }
#      }
#
#      repoServer = {
#        autoscaling = {
#          minReplicas = 2
#        }
#      }
#
#      server = {
#        autoscaling = {
#          enabled = true
#        }
#      }
#
#      server = {
#        autoscaling = {
#          minReplicas = 2
#        }
#      }
#    })
#  ]
#}