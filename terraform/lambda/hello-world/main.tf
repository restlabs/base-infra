locals {
  architecture  = "x86_64"
  code_dir      = "../../../aws/lambda/hello-world"
  function_name = "hello-world-lambda"
  handler       = "main"
  runtime       = "provided.al2023"
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${local.function_name}-role"
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
  architecture     = [local.architecture]
  description      = "Hello World Lambda"
  filename         = "${local.code_dir}/main.zip"
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
