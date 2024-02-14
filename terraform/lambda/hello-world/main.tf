locals {
  architecture  = "arm64"
  code_dir      = "../../../aws/lambda/hello-world"
  function_name = "hello-world-lambda"
  handler       = "bootstrap" # handler function needs to be named bootstrap
  runtime       = "provided.al2023"
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${local.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "null_resource" "delete_go_files" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "rm -rf ${local.code_dir}/${local.handler} && rm -rf ${local.code_dir}/${local.handler}.zip"
  }
}

resource "null_resource" "package_file" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "cd ${local.code_dir} && GOOS=linux GOARCH=arm64 go build -o ${local.handler}"
  }

  depends_on = [null_resource.delete_go_files]
}

resource "aws_lambda_function" "tf_lambda" {
  architectures    = [local.architecture]
  description      = "Hello World Lambda"
  filename         = "${local.code_dir}/${local.handler}.zip"
  function_name    = local.function_name
  handler          = local.handler
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = local.runtime
  source_code_hash = data.archive_file.go_main.output_base64sha256

  environment {
    variables = {
      foo = "bar"
    }
  }

  depends_on = [null_resource.package_file]
}
