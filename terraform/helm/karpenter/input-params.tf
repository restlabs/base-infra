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

data "aws_ssm_parameter" "eks_nodegroup_role_arn" {
  provider = aws.parameters
  name     = "/eks/iam/role/nodegroup/arn"
}

data "aws_ssm_parameter" "eks_nodegroup_role_name" {
  provider = aws.parameters
  name     = "/eks/iam/role/nodegroup/name"
}

data "aws_ssm_parameter" "account_env" {
  provider = aws.parameters
  name     = "/account/environment"
}

data "aws_ssm_parameter" "github_org_url" {
  provider = aws.parameters
  name     = "/github/organization/url"
}

data "aws_ssm_parameter" "github_app_id" {
  provider = aws.parameters
  name     = "/gihub/app/id"
}

data "aws_ssm_parameter" "github_app_install_id" {
  provider = aws.parameters
  name     = "/github/app/installation/id"
}

data "aws_ssm_parameter" "github_app_private_key" {
  provider = aws.parameters
  name     = "/github/app/private/key"
}

data "aws_ssm_parameter" "eks_oidc_arn" {
  provider = aws.parameters
  name     = "/eks/oidc/provider/arn"
}