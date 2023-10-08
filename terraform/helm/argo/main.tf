locals {
  cluster_name     = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  isLB             = false
  service_type_name  = isLB ? "server.service.type" : null
  service_type_value = isLB ? "LoadBalancer" : null
}

resource "helm_release" "argocd" {
  chart            = "argo-cd"
  create_namespace = true
  name             = "argo"
  namespace        = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "5.46.7"

  set {
    name  = "redis-ha.enabled"
    value = true
  }

  set {
    name  = "controller.replicas"
    value = 1
  }

  set {
    name  = "server.autoscaling.enabled"
    value = true
  }

  set {
    name  = "server.autoscaling.minReplicas"
    value = 2
  }

  set {
    name  = "repoServer.autoscaling.enabled"
    value = true
  }

  set {
    name  = "repoServer.autoscaling.minReplicas"
    value = 2
  }

  set {
    name  = "applicationSet.replicaCount"
    value = 2
  }

  set {
    name  = local.service_type_name
    value = local.service_type_value
  }
}