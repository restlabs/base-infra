data "aws_ssm_parameter" "account_env" {
  name     = "/account/environment"
  provider = aws.parameters
}