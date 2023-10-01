variable "eks_nodegroup_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "environment" {
  type        = string
  description = "Environment for this project. Default is poc = proof of concept "
  default     = "poc"
}

variable "owner" {}

variable "email" {}

variable "region" {
  type        = string
  description = "AWS region to deploy the cluster to"
}
