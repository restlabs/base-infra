resource "aws_ssm_parameter" "ssm_param_output" {
  for_each = {
    for v in var.params :

    v.name => {
      value       = v.value
      description = v.description
    }
  }

  description = each.value.description
  overwrite   = true
  name        = each.key
  tags        = var.tags
  type        = "String"
  value       = each.value.value
}
