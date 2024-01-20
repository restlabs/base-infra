module "kubernetes" {
  source = "../terraform/modules/kubernetes-version"
}

module "terraform_aws_version" {
  source = "../terraform/modules/terraform-aws-version"
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = data.aws_ssm_parameter.eks_cluster_endpoint.value
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
}

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

variable "email" {
  type        = string
  description = "email"
  default     = "pafable@test"
}

variable "owner" {
  type        = string
  description = "owner"
  default     = "pafable"
}

variable "region" {
  type        = string
  description = "region"
  default     = "us-east-2"
}

data "aws_ssm_parameter" "eks_cluster_name" {
  provider = aws.parameters
  name     = "/eks/base/id"
}

data "aws_ssm_parameter" "eks_cluster_endpoint" {
  provider = aws.parameters
  name     = "/eks/base/endpoint"
}

data "aws_eks_cluster" "eks_cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = local.cluster_name
}

data "aws_ssm_parameter" "account_env" {
  provider = aws.parameters
  name     = "/account/environment"
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