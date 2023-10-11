variable "project" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "is_public_ip_on" {
  type    = bool
  default = false
}

variable "subnet_list" {
  type = set(string)
}

variable "subnet_type" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}