module "terraform_aws_version" {
  source = "../../modules/terraform-aws-version"
}

module "helm_version" {
  source = "../../modules/helm-version"
}

locals {
  base_tags = {
    base_tags = {
      owner         = var.owner
      code_location = "terraform/helm/argocd"
      project       = "base-infra"
      email         = var.email
      environment   = var.environment
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = local.base_tags
  }
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
  default_tags {
    tags = local.base_tags
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_ssm_parameter.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_cluster.token
  }
}