provider "helm" {
  kubernetes {
    host                   = data.aws_ssm_parameter.eks_endpoint.value
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.base_eks.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", data.aws_ssm_parameter.eks_cluster_name.value]
    }
  }
}