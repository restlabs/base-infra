locals {
  cluster_name = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  file         = "nexus.yaml"
  path         = "../../../../kubernetes/manifests/nexus/%s"
}

resource "kubernetes_manifest" "nexus_app" {
  manifest = yamldecode(
    file(
      format(
        local.path,
        local.file
      )
    )
  )
}
