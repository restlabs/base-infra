variable "app_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "code_location" {
  type = string
}

variable "email" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = { Name = "foo" }
}