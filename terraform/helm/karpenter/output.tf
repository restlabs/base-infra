output "oidc" {
  value = data.aws_eks_cluster.eks_cluster.identity[0].oidc
}