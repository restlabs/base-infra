output "eks_cluster_role_arn" {
  value = module.base_eks.eks_cluster_role_arn
}

output "eks_nodegroup_role" {
  value = module.base_eks.eks_nodegroup_role
}

output "eks_fargate_role" {
  value = module.base_eks.eks_fargate_role
}

output "eks_arn" {
  value = module.base_eks.eks_arn
}

output "eks_cluster_name" {
  value = module.base_eks.eks_cluster_id
}

output "eks_endpoint" {
  value = module.base_eks.eks_endpoint
}

output "eks_status" {
  value = module.base_eks.eks_status
}