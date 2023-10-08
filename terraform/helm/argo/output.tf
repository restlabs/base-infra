output "argo_status" {
  value = module.argo.status
}

output "argo_metadata" {
  value = module.argo.metadata
}

output "repositories" {
  value = module.argo.values
}