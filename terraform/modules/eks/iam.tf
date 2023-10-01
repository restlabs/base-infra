# Node group
resource "aws_iam_role" "eks_nodegroup_role" {
  name               = "${local.cluster_name}-nodegroup-role"
  description        = "Node group role for ${local.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.eks_nodegroup_policy.json
  managed_policy_arns = [
    data.aws_iam_policy.eks_nodegroup_cni_policy.arn,
    data.aws_iam_policy.eks_nodegroup_ecr_policy.arn,
    data.aws_iam_policy.eks_nodegroup_eksworker_policy.arn
  ]
}

# Fargate
resource "aws_iam_role" "eks_fargate_role" {
  name                = "${local.cluster_name}-fargate-role"
  description         = "EKS Fargate role for ${local.cluster_name}"
  assume_role_policy  = data.aws_iam_policy_document.eks_fargate_policy.json
  managed_policy_arns = [data.aws_iam_policy.fargate_policy.arn]
}

# EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name                = "${local.cluster_name}-cluster-role"
  description         = "EKS cluster role for ${local.cluster_name}"
  assume_role_policy  = data.aws_iam_policy_document.eks_cluster_policy.json
  managed_policy_arns = [data.aws_iam_policy.eks_cluster_policy.arn]
}
