output "status" {
  value = helm_release.tf_helm.status
}

output "metadata" {
  value = helm_release.tf_helm.metadata
}

output "values" {
  value = helm_release.tf_helm.values
}