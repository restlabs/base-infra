locals {
  cluster_name  = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  file = "argo-example-app.yaml"
  path = "../../../../kubernetes/manifests/argo-example-app/%s"
}

resource "kubernetes_manifest" "argo_example_app" {
  manifest = yamldecode(
    file(
      format(
        local.path,
        local.file
      )
    )
  )
}
