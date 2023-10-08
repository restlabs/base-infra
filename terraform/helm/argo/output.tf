output "argo_status" {
  value = helm_release.argocd.status
}

output "argo_metadata" {
  value = helm_release.argocd.metadata
}

output "repositories" {
  value = helm_release.argocd.values
}