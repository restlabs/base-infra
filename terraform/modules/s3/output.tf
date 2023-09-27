output "bucket_name" {
  value = aws_s3_bucket.tf_bucket.id
}

output "bucket_region" {
  value = aws_s3_bucket.tf_bucket.region
}

output "bucket_tags" {
  value = aws_s3_bucket.tf_bucket.tags_all
}
