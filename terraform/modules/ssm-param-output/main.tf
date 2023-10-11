resource "aws_ssm_parameter" "s3_ssm_arn" {
  for_each = {
    for v in var.params :

    v.name => {
      value       = v.value
      description = v.description
    }
  }

  name        = each.key
  type        = "String"
  value       = each.value.value
  description = each.value.description
  tags        = var.tags
}
