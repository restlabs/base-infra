module "base_eks" {
  source                      = "../../modules/eks"
  eks_nodegroup_instance_type = var.eks_nodegroup_instance_type
  environment                 = var.environment
  isDefaultVpc                = true
  owner                       = var.owner
  region                      = var.region
  vpc_id                      = null
}
