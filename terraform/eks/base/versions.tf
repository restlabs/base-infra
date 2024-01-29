locals {
  base_tags = {
    branch        = var.branch
    code_location = "terraform/eks/base"
    commit        = var.commit
    owner         = var.owner
    project       = "base-infra"
    email         = var.email
    environment   = nonsensitive(data.aws_ssm_parameter.account_env.value)
  }

  use_localstack = (terraform.workspace == "ci-test")

  aws_settings = (
    local.use_localstack ?
    {
      skip_credentials_validation = true
      skip_metadata_api_check     = true
      skip_requesting_account_id  = true

      override_endpoint = "http://localhost:4566"
    } :
    {
      skip_credentials_validation = null
      skip_metadata_api_check     = null
      skip_requesting_account_id  = null

      override_endpoint = null
    }
  )
}

module "terraform_aws_version" {
  source = "../../modules/terraform-aws-version"
}

module "kubernetes-version" {
  source = "../../modules/kubernetes-version"
}

module "helm-version" {
  source = "../../modules/helm-version"
}

module "kubectl-version" {
  source = "../../modules/kubectl-version"
}

terraform {
  backend "s3" {}
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "aws" {
  region = var.region

  skip_credentials_validation = local.aws_settings.skip_credentials_validation
  skip_metadata_api_check     = local.aws_settings.skip_metadata_api_check
  skip_requesting_account_id  = local.aws_settings.skip_requesting_account_id

  dynamic "endpoints" {
    for_each = local.aws_settings.override_endpoint[*]
    content {
      ec2 = endpoints.value
      iam = endpoints.value
    }
  }

  default_tags {
    tags = local.base_tags
  }
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    host                   = module.base_eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.base_eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.base_eks.cluster_name]
    }
  }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = module.base_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.base_eks.cluster_certificate_authority_data)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.base_eks.cluster_name]
  }
}

provider "kubernetes" {
  host                   = module.base_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.base_eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.base_eks.cluster_name]
  }
}
