resource "aws_s3_bucket" "tf_bucket" {
  bucket = "${var.app_name}-bucket-${var.environment}-${var.region}"
}