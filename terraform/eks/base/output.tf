output "eks_cluster_name" {
  value = nonsensitive(module.base_eks.cluster_name)
}

output "eks_cluster_arn" {
  value = module.base_eks.cluster_arn
}

output "eks_cluster_role" {
  value = module.base_eks.cluster_iam_role_arn
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