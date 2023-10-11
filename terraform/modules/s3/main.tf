locals {
  environment = try(var.tags.environment, "test")
}

resource "aws_s3_bucket" "tf_bucket" {
  bucket = "${var.app_name}-bucket-${local.environment}-${var.region}"
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "tf_s3_block_public_acl" {
  bucket                  = aws_s3_bucket.tf_bucket.id
  block_public_acls       = var.block_public_acl
  block_public_policy     = var.block_public_acl
  ignore_public_acls      = var.block_public_acl
  restrict_public_buckets = var.block_public_acl
}

resource "aws_s3_bucket_versioning" "tf_s3_versioning" {
  bucket = aws_s3_bucket.tf_bucket.id
  versioning_configuration {
    status = var.is_versioning_enabled
  }
}
