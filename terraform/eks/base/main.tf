locals {
  ami_type                   = "AL2_x86_64"
  cluster_name               = "${var.owner}-${local.base_tags.environment}-eks-${var.region}"
  create_iam_role            = false
  eks_version                = 1.28
  disk_size                  = 50
  desired_size               = 1
  max_size                   = 3
  min_size                   = 1
  instance_types             = ["t3.small"]
  is_private_access_enabled  = local.base_tags.environment == "test" || local.base_tags.environment == "dev" ? false : true
  is_public_access_enabled   = local.base_tags.environment == "test" || local.base_tags.environment == "dev" ? true : false
  use_custom_launch_template = true
}

module "base_eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.17.2"
  cluster_name    = local.cluster_name
  cluster_version = local.eks_version
  #  cluster_endpoint_public_access_cidrs = [ data.aws_ssm_parameter.my_public_ip.value ]
  control_plane_subnet_ids        = data.aws_subnets.tf_subnet.ids
  cluster_endpoint_private_access = local.is_private_access_enabled
  cluster_endpoint_public_access  = local.is_public_access_enabled
  iam_role_arn                    = aws_iam_role.eks_cluster_role.arn
  subnet_ids                      = data.aws_subnets.tf_subnet.ids
  vpc_id                          = data.aws_vpc.selected.id

  eks_managed_node_groups = {
    pafable-default = {
      ami_type                   = local.ami_type
      create_iam_role            = local.create_iam_role
      disk_size                  = local.disk_size
      desired_size               = local.desired_size
      iam_role_arn               = aws_iam_role.nodegroup_role.arn
      instance_types             = local.instance_types
      min_size                   = local.min_size
      max_size                   = local.max_size
      use_custom_launch_template = local.use_custom_launch_template
      launch_template_tags = {
        Name = "${local.base_tags.project}-eks-default-node"
      }
    }
  }
}

