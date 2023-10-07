locals {
  cluster_name = "${var.owner}-${var.environment}-eks-${var.region}"
}

resource "helm_release" "argocd" {
  chart            = "argo"
  create_namespace = true
  name             = "argo"
  namespace        = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "5.46.7"
}