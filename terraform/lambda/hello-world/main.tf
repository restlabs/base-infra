locals {
  function_name = "hello-world-lambda"
  code_dir      = "../../../aws/lambda/hello-world"
}

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

resource "aws_iam_role" "iam_for_lambda" {
  name               = "hello-world-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "null_resource" "package_file" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "cd ${local.code_dir} && rm -rf main && rm -rf main.zip && GOOS=linux GOARCH=amd64 go build -o main"
  }
}

resource "aws_lambda_function" "tf_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${local.code_dir}/main.zip"
  function_name = local.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main"

  source_code_hash = data.archive_file.go_main.output_base64sha256

  runtime = "go1.x"

  environment {
    variables = {
      foo = "bar"
    }
  }

  depends_on = [null_resource.package_file]
}

data "archive_file" "go_main" {
  type        = "zip"
  source_file = "${local.code_dir}/main"
  output_path = "${local.code_dir}/main.zip"

  depends_on = [null_resource.package_file]
}