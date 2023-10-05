variable "app_name" {
  type = string
}

variable "block_public_acl" {
  type    = bool
  default = true
}

variable "code_location" {
  type = string
}

variable "is_versioning_enabled" {
  type    = string
  default = "Enabled"
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
