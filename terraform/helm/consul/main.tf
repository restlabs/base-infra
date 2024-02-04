# THIS NEEDS TO BE DEPLOYED AFTER THE EKS CLUSTER IS CREATED!
# I Separated Consul to it's own folder because it's causing issues with updating and destroying releases in helm

locals {
  consul_name          = "consul"
  consul_chart_name    = "hashicorp/${local.consul_name}"
  consul_repo          = "https://helm.releases.hashicorp.com"
  consul_chart_version = "1.0.0"
  consul_version       = "1.14.8"
  release_name         = "consul"
  timeout              = 500

  values_map = {
    connectInject = {
      enabled = true
      default = true
    }

    controller = {
      enabled = true
    }

    global = {
      datacenter = "eks"
      image      = "${local.consul_chart_name}:${local.consul_version}"
      name       = "eks-consul"
      peering = {
        enabled = true
      }
      tls = {
        enabled = true
      }
    }

    meshGateway = {
      enabled  = true
      replicas = 1
    }

    server = {
      replicas        = 2
      bootstrapExpect = 2
      #      extraConfig     = <<EOF
      #        {
      #          log_level = "TRACE"
      #        }
      #      EOF
      #      storage = {
      #        size = "10Gi"
      #      }
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
  release_name  = local.release_name
  repository    = local.consul_repo
  timeout       = local.timeout
  values_map    = local.values_map
}