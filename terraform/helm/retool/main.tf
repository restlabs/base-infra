locals {
  chart_name    = "retool"
  chart_repo    = "retool url"
  chart_version = "0.1.0"
  timeout       = 500

  values_map = {
    "retool" = {
      "config" = {
        "license" = {
          "key" = "license key"
        }
      }
    }
  }
}


module "retool" {
  source        = "../../modules/helm-install"
  chart         = local.chart_name
  chart_version = local.chart_version
  namespace     = local.chart_name
  release_name  = local.chart_name
  repository    = local.chart_repo
  timeout       = local.timeout
  values_map    = local.values_map
}