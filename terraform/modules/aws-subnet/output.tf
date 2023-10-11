output "subnet_ids" {
  value = [for private in aws_subnet.tf_subnets : private.id]
}