variable "app_name" {
  type    = string
  default = "hello-world-lambda"
}

variable "branch" {
  type = string
}

variable "commit" {
  type = string
}

variable "email" {}

variable "owner" {}

variable "params_region" {
  type    = string
  default = "us-east-1"
}

variable "region" {}
