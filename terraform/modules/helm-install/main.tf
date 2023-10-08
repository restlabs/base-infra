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
}