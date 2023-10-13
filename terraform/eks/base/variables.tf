variable "branch" {
  type = string
}

variable "commit" {
  type = string
}

variable "eks_nodegroup_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "owner" {}

variable "email" {}

variable "region" {
  type        = string
  description = "AWS region to deploy the cluster to"
}
