module "base_eks" {
  source                      = "../../modules/eks"
  code_location               = "terraform/eks/base"
  eks_nodegroup_instance_type = var.eks_nodegroup_instance_type
  eks_version                 = 1.28
  email                       = var.email
  environment                 = var.environment
  isDefaultVpc                = true
  owner                       = var.owner
  project                     = "base-infra"
  region                      = var.region
  vpc_id                      = null
}
