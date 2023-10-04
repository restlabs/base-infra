variable "app_name" {
  type    = string
  default = "base-infra"
}

variable "availability_zones" {
  default = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c"
  ]
}

variable "email" {}

variable "owner" {}

variable "region" {}
