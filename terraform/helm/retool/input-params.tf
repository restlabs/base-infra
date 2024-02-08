data "aws_ssm_parameter" "eks_endpoint" {
  provider = "aws.parameters"
  name     = "/eks/base/endpoint"
}

data "aws_ssm_parameter" "eks_id" {
  provider = "aws.parameters"
  name     = "/eks/base/id"
}

data "aws_eks_cluster" "base_eks" {
  name = data.aws_ssm_parameter.eks_id.value
}