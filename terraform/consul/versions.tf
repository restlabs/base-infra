module "terraform_aws_version" {
  source = "../modules/terraform-aws-version"
}

module "helm-version" {
  source = "../modules/helm-version"
}

terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_ssm_parameter.eks_endpoint.value
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.base_eks.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.base_eks.name]
    }
  }
}