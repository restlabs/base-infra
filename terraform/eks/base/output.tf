output "eks_cluster_name" {
  value = module.base_eks.cluster_name
}

output "eks_cluster_arn" {
  value = module.base_eks.cluster_arn
}

output "eks_cluster_role" {
  value = module.base_eks.cluster_iam_role_arn
}

output "eks_iam_role_arn" {
  value = aws_iam_role.nodegroup_role.arn
}

output "eks_fargate_role" {
  value = module.base_eks.fargate_profiles
}

output "eks_endpoint" {
  value = module.base_eks.cluster_endpoint
}

output "eks_status" {
  value = module.base_eks.cluster_status
}

output "eks_oidc_arn" {
  value = module.base_eks.oidc_provider_arn
}
