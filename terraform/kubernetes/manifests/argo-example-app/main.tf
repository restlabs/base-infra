locals {
  path = "../../../../kubernetes/manifests/argo-example-app/%s"
  file = "argo-example-app.yaml"
}

output "tempfile" {
  value = yamldecode(
    file(
      format(
        local.path,
        local.file
      )
    )
  )
}