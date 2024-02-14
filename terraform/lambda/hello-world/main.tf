locals {
  architecture   = "arm64" # use either amd64 or arm64
  code_dir       = "../../../aws/lambda/hello-world"
  cpu_arch       = local.architecture == "amd64" ? "x86_64" : "arm64"
  executable     = "${local.code_dir}/${local.handler}"
  executable_zip = "${local.executable}.zip"
  function_name  = "hello-world-lambda"
  handler        = "bootstrap" # handler function needs to be named bootstrap
  runtime        = "provided.al2023"
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
    command = "rm -rf ${local.executable} && rm -rf ${local.executable_zip}"
  }
}

resource "null_resource" "package_file" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "cd ${local.code_dir} && GOOS=linux GOARCH=${local.architecture} go build -o ${local.handler}"
  }

  depends_on = [null_resource.delete_go_files]
}

resource "aws_lambda_function" "tf_lambda" {
  architectures    = [local.cpu_arch]
  description      = "Hello World Lambda"
  filename         = local.executable_zip
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
