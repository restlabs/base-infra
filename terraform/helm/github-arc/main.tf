locals {
  cluster_name             = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  controller_chart         = "gha-runner-scale-set-controller"
  controller_chart_version = "0.6.1"
  controller_namespace     = "actions-runner-controller"
  controller_repository    = "oci://ghcr.io/actions/actions-runner-controller-charts"
  scale_set_chart          = "gha-runner-scale-set"
  scale_set_namespace      = "actions-runner-scale-set"

  values_map = {
    # create a github org
    githubConfigUrl = data.aws_ssm_parameter.github_org_url.value

    # create secrets in github app
    githubConfigSecret = {
      github_app_id              = data.aws_ssm_parameter.github_app_id.value
      github_app_installation_id = data.aws_ssm_parameter.github_app_install_id.value
      github_app_private_key     = data.aws_ssm_parameter.github_app_private_key.value
    }

    maxRunners         = 20
    minRunners         = 0
    runnerScaleSetName = "hydra"
  }
}

module "arc_controller" {
  source        = "../../modules/helm-install"
  chart         = local.controller_chart
  chart_version = local.controller_chart_version
  namespace     = local.controller_namespace
  release_name  = local.controller_namespace
  repository    = local.controller_repository
  values_map    = {}
}

module "arc_scale_set" {
  source        = "../../modules/helm-install"
  chart         = local.scale_set_chart
  chart_version = local.controller_chart_version
  namespace     = local.scale_set_namespace
  release_name  = local.scale_set_namespace
  repository    = local.controller_repository
  values_map    = local.values_map
  depends_on    = [ module.arc_controller ]
}