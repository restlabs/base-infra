locals {
  cluster_name  = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  file = "jenkins-example.yaml"
  path = "../../../../kubernetes/manifests/jenkins-example/%s"
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
