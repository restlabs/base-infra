locals {
  ami_type         = "AL2_x86_64"
  cluster_name     = "${var.owner}-${var.environment}-eks-${var.region}"
  desired_capacity = 3
  max_capacity     = 4
  min_capacity     = 2
  instance_types   = ["t3.small"]
}

data "aws_ssm_parameter" "base_vpc_id" {
  provider = "aws.parameters"
  name     = "/vpc/base/id"
}

data "aws_vpc" "selected" {
  id = data.aws_ssm_parameter.base_vpc_id.value
}

data "aws_subnets" "tf_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    subnet_type = "public"
  }
}

module "base_eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.16.0"
  cluster_name    = local.cluster_name
  cluster_version = 1.28
  # cluster_endpoint_public_access_cidrs = [] # set this when going to prod
  control_plane_subnet_ids = data.aws_subnets.tf_subnet.ids
  vpc_id                   = data.aws_vpc.selected.id
  eks_managed_node_group_defaults = {
    ami_type         = local.ami_type
    desired_capacity = local.desired_capacity
    max_capacity     = local.max_capacity
    min_capacity     = local.min_capacity
    instance_types   = local.instance_types
  }
}
