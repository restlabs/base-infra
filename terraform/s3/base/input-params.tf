data "aws_ssm_parameter" "account_env" {
  provider = aws.parameters
  name     = "/account/env"
}
