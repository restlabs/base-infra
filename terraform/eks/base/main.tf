locals {
  ami_type                     = "AL2_x86_64"
  azure_application_id         = data.aws_ssm_parameter.azure_application_id.value
  azure_tenant_id              = data.aws_ssm_parameter.azure_tenant_id.value
  capacity_type                = "SPOT"
  cluster_name                 = "${var.owner}-eks-${var.region}"
  create_iam_role              = false
  eks_version                  = 1.28
  disk_size                    = 50
  desired_size                 = 1
  max_size                     = 3
  min_size                     = 1
  managed_nodes_instance_types = ["t3.small"]
  is_private_access_enabled    = local.base_tags.environment == "test" || local.base_tags.environment == "dev" ? false : true
  is_public_access_enabled     = local.base_tags.environment == "test" || local.base_tags.environment == "dev" ? true : false
  use_custom_launch_template   = true
}

module "base_eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.21.0"
  cluster_name                    = local.cluster_name
  cluster_version                 = local.eks_version
  control_plane_subnet_ids        = module.vpc.intra_subnets
  cluster_endpoint_private_access = local.is_private_access_enabled
  cluster_endpoint_public_access  = local.is_public_access_enabled
  create_cluster_security_group   = false
  create_node_security_group      = false
  iam_role_arn                    = aws_iam_role.eks_cluster_role.arn
  manage_aws_auth_configmap       = true
  subnet_ids                      = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id

  # creates karpenter node IAM role
  aws_auth_roles = [
    {
      rolearn  = module.karpenter.role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes"
      ]
    },
  ]

  cluster_addons = {
    kube-proxy = {}
    vpc-cni    = {}
    coredns = {
      configuration_values = jsonencode({
        computeType = "Fargate"
        # Ensure that we fully utilize the minimum amount of resources that are supplied by
        # Fargate https://docs.aws.amazon.com/eks/latest/userguide/fargate-pod-configuration.html
        # Fargate adds 256 MB to each pod's memory reservation for the required Kubernetes
        # components (kubelet, kube-proxy, and containerd). Fargate rounds up to the following
        # compute configuration that most closely matches the sum of vCPU and memory requests in
        # order to ensure pods always have the resources that they need to run.
        resources = {
          limits = {
            cpu = "0.25"
            # We are targeting the smallest Task size of 512Mb, so we subtract 256Mb from the
            # request/limit to ensure we can fit within that task
            memory = "256M"
          }
          requests = {
            cpu = "0.25"
            # We are targeting the smallest Task size of 512Mb, so we subtract 256Mb from the
            # request/limit to ensure we can fit within that task
            memory = "256M"
          }
        }
      })
    }
  }

  # creates fargate profiles
  fargate_profiles = {
    karpenter = {
      selectors = [
        { namespace = "karpenter" }
      ]
    }
    kube-system = {
      selectors = [
        { namespace = "kube-system" }
      ]
    }
  }

  # ports needed by example-microservice-for-consul-testing
  # this is wide open for the demo, when going to prod lock this down!
  # Use the link below to see what ports are needed
  # https://developer.hashicorp.com/consul/docs/install/ports
  node_security_group_additional_rules = {
    all_ingress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # IAM policy needed by example-microservice-for-consul-testing for EBS storage creation
  iam_role_additional_policies = {
    AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }

  # adds azure ad as an identity provider
  # this will allow users to use kubectl with their ad credentials
  #  cluster_identity_providers = {
  #    azure-ad = {
  #      client_id    = local.azure_application_id
  #      issuer_url   = "https://sts.windows.net/${local.azure_tenant_id}/"
  #      groups_claim = "groups"
  #    }
  #  }
  #
  #  eks_managed_node_groups = {
  #    pafable-main = {
  #      ami_type                   = local.ami_type
  #      capacity_type              = local.capacity_type
  #      create_iam_role            = local.create_iam_role
  #      disk_size                  = local.disk_size
  #      desired_size               = local.desired_size
  #      iam_role_arn               = aws_iam_role.nodegroup_role.arn
  #      instance_types             = local.managed_nodes_instance_types
  #      min_size                   = local.min_size
  #      max_size                   = local.max_size
  #      use_custom_launch_template = local.use_custom_launch_template
  #      launch_template_tags = {
  #        Name = "${local.base_tags.project}-eks-default-node"
  #      }
  #    }
  #  }

  tags = merge(
    local.base_tags,
    {
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "karpenter.sh/discovery"                      = local.cluster_name
    }
  )
}

# enables ebs-csi-driver addon for ebs storage for example-microservice-for-consul-testing
resource "aws_eks_addon" "ebs" {
  cluster_name = module.base_eks.cluster_name
  addon_name   = "aws-ebs-csi-driver"
}

module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.base_eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
