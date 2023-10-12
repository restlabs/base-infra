output "controller_status" {
  value = module.arc_controller.status
}

output "scale_set_status" {
  value = module.arc_scale_set.status
}
