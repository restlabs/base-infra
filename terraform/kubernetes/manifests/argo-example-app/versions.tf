module "kubernetes" {
  source = "../../../modules/kubernetes-version"
}

module "terraform_aws_version" {
  source = "../../../modules/terraform-aws-version"
}

locals {
  base_tags = {
    code_location = "terraform/manifests/argo-example-app"
    email         = var.email
    environment   = data.aws_ssm_parameter.account_env.value
    owner         = var.owner
    project       = "base-infra"
  }
}

terraform {
  backend "s3" {}
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
}

provider "kubernetes" {
  host                   = data.aws_ssm_parameter.eks_cluster_endpoint.value
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
}