locals {
  cluster_name = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  base_tags = {
    code_location = "terraform/manifests/jenkins-example"
    email         = var.email
    environment   = data.aws_ssm_parameter.account_env.value
    owner         = var.owner
    project       = "base-infra"
  }
}

resource "kubernetes_namespace_v1" "example_ns" {
  metadata {
    name = "jenkins"
    labels = {
      component = "cicd"
    }
  }
}

resource "kubernetes_deployment_v1" "example" {
  metadata {
    name = "jenkins"
    namespace = kubernetes_namespace_v1.example_ns.metadata[0].name
    labels = {
      component = "cicd"
    }
  }

  spec {
    strategy {
      type = "RollingUpdate"
    }
    replicas = 1

    selector {
      match_labels = {
        component = "cicd"
      }
    }

    template {
      metadata {
        labels = {
          component = "cicd"
          version   = "v2"
        }
      }

      spec {
        restart_policy = "Always"
        security_context {
          fs_group    = "1000"
          run_as_user = "0"
        }

        container {
          image = "jenkins/jenkins:latest"
          name  = "jenkins-container"

          port {
            container_port = 8080
            name           = "jenkins-port"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace_v1.example_ns]
}