variable "app_name" {
  description = "app name"
  type        = string
}

variable "email" {
  description = "email"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

variable "owner" {
  description = "owner"
  type        = string
}

variable "project" {
  description = "project"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}
