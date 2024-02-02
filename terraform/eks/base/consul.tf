locals {
  consul_name          = "consul"
  consul_chart_name    = "hashicorp/${local.consul_name}"
  consul_repo          = "https://helm.releases.hashicorp.com"
  consul_chart_version = "1.3.2"
  consul_version       = "1.14.8"
  timeout              = 900

  values_map = {
    global = {
      image = "${local.consul_chart_name}:${local.consul_version}"
      peering = {
        enabled = true
      }
      tls = {
        enabled = true
      }
    }

    server = {
      replicas        = 3
      bootstrapExpect = 3
      extraConfig     = <<EOF
        {
          log_level = "TRACE"
        }
      EOF
      #      storage = {
      #        size = "10Gi"
      #      }
    }

    connectInject = {
      enabled = true
      default = true
    }

    meshGateway = {
      enabled  = true
      replicas = 1
    }

    controller = {
      enabled = true
    }

    ui = {
      enabled = true
      service = {
        enabled = true
        type    = "LoadBalancer"
      }
    }
  }
}

module "consul" {
  source        = "../../modules/helm-install"
  chart         = local.consul_name
  chart_version = local.consul_chart_version
  namespace     = local.consul_name
  release_name  = local.consul_name
  repository    = local.consul_repo
  timeout       = local.timeout
  values_map    = local.values_map

  depends_on = [module.base_eks]
}
