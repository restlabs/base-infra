output "vpc_is_dns_support_enabled" {
  value = aws_vpc.tf_vpc.enable_dns_support
}

output "vpc_id" {
  value = aws_vpc.tf_vpc.id
}

output "vpc_tags" {
  value = aws_vpc.tf_vpc.tags_all
}
