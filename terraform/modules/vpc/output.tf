output "vpc_is_dns_support_enabled" {
  value = aws_vpc.tf_vpc.enable_dns_support
}

output "vpc_arn" {
  value = aws_vpc.tf_vpc.arn
}

output "vpc_id" {
  value = aws_vpc.tf_vpc.id
}

output "vpc_tags" {
  value = aws_vpc.tf_vpc.tags_all
}

output "default_route_table_id" {
  value = aws_vpc.tf_vpc.default_route_table_id
}
