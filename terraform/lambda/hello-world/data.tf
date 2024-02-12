data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "archive_file" "go_main" {
  type        = "zip"
  source_file = "${local.code_dir}/main"
  output_path = "${local.code_dir}/main.zip"

  depends_on = [null_resource.package_file]
}
