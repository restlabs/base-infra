data "aws_ssm_parameter" "account_env" {
  name     = "/account/env"
  provider = aws.parameters
}
