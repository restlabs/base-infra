resource "helm_release" "tf_helm" {
  chart            = var.chart
  create_namespace = var.create_namespace
  name             = var.release_name
  namespace        = var.namespace
  repository       = var.repository
  timeout          = try(var.timeout, 300)
  version          = var.chart_version

  values = [
    yamlencode(
      var.values_map
    )
  ]
}