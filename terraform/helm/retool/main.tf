locals {
  chart_name    = "retool"
  chart_repo    = "https://charts.retool.com/"
  chart_version = "6.0.13"
  timeout       = 500

  values_map = {
    "config" = {
      "licenseKey" = data.aws_ssm_parameter.retool_license_key.value
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