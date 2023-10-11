variable "app_name" {
  type = string
}

variable "block_public_acl" {
  type    = bool
  default = true
}

variable "is_versioning_enabled" {
  type    = string
  default = "Enabled"
}

variable "region" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = { Name = "foo" }
}
