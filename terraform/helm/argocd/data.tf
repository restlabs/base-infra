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