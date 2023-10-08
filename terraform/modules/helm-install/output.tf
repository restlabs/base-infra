output "status" {
  value = helm_release.argocd.status
}

output "metadata" {
  value = helm_release.argocd.metadata
}

output "values" {
  value = helm_release.argocd.values
}