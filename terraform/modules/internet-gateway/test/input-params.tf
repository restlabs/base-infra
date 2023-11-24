data "aws_ssm_parameter" "account_env" {
  name     = "/account/environment"
  provider = aws.parameters
}

data "aws_ssm_parameter" "vpc_id" {
  name     = "/vpc/base/id"
  provider = aws.parameters
}