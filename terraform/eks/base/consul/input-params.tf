data "aws_ssm_parameter" "eks_cluster_name" {
  provider = aws.parameters
  name     = "/eks/base/id"
}

data "aws_ssm_parameter" "eks_endpoint" {
  provider = aws.parameters
  name     = "/eks/base/endpoint"
}

data "aws_eks_cluster" "base_eks" {
  name = data.aws_ssm_parameter.eks_cluster_name.value
}