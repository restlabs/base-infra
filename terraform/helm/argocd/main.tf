data "aws_ssm_parameter" "eks_cluster_name" {
  provider = aws.parameters
  name = "/eks/base/id"
}