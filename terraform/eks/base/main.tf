locals {
  ami_type                   = "AL2_x86_64"
  azure_application_id       = data.aws_ssm_parameter.azure_application_id.value
  azure_tenant_id            = data.aws_ssm_parameter.azure_tenant_id.value
  capacity_type              = "SPOT"
  cluster_name               = "${var.owner}-eks-${var.region}"
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
  version         = "19.21.0"
  cluster_name    = local.cluster_name
  cluster_version = local.eks_version
  #  cluster_endpoint_public_access_cidrs = [ data.aws_ssm_parameter.my_public_ip.value ]
  control_plane_subnet_ids        = data.aws_subnets.tf_subnet.ids
  cluster_endpoint_private_access = local.is_private_access_enabled
  cluster_endpoint_public_access  = local.is_public_access_enabled
  iam_role_arn                    = aws_iam_role.eks_cluster_role.arn
  subnet_ids                      = data.aws_subnets.tf_subnet.ids
  vpc_id                          = data.aws_vpc.selected.id

  # adds azure ad as an identity provider
  # this will allow users to use kubectl with their ad credentials
  cluster_identity_providers = {
    azure-ad = {
      client_id    = local.azure_application_id
      issuer_url   = "https://sts.windows.net/${local.azure_tenant_id}/"
      groups_claim = "groups"
    }
  }

  eks_managed_node_groups = {
    pafable-main = {
      ami_type                   = local.ami_type
      capacity_type              = local.capacity_type
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

# karpenter

module "karpenter" {
  source                                     = "terraform-aws-modules/eks/aws//modules/karpenter"
  version                                    = "19.21.0"
  cluster_name                               = module.base_eks.cluster_name
  irsa_oidc_provider_arn                     = module.base_eks.oidc_provider_arn
  enable_karpenter_instance_profile_creation = true

  iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "v0.32.6"

  values = [
    <<-EOT
    settings:
      clusterName: ${module.base_eks.cluster_name}
      clusterEndpoint: ${module.base_eks.cluster_endpoint}
      interruptionQueueName: ${module.karpenter.queue_name}
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: ${module.karpenter.irsa_arn}
    EOT
  ]

  depends_on = [
    module.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1beta1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      amiFamily: AL2
      role: ${module.karpenter.role_name}
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${module.base_eks.cluster_name}
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${module.base_eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.base_eks.cluster_name}
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1beta1
    kind: NodePool
    metadata:
      name: default
    spec:
      template:
        spec:
          nodeClassRef:
            name: default
          requirements:
            - key: "karpenter.k8s.aws/instance-category"
              operator: In
              values: ["c", "m", "r"]
            - key: "karpenter.k8s.aws/instance-cpu"
              operator: In
              values: ["4", "8", "16", "32"]
            - key: "karpenter.k8s.aws/instance-hypervisor"
              operator: In
              values: ["nitro"]
            - key: "karpenter.k8s.aws/instance-generation"
              operator: Gt
              values: ["2"]
      limits:
        cpu: 1000
      disruption:
        consolidationPolicy: WhenEmpty
        consolidateAfter: 30s
  YAML

  depends_on = [
    kubectl_manifest.karpenter_node_class
  ]
}

# Test deployment
resource "kubectl_manifest" "karpenter_example_deployment" {
  yaml_body = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: inflate
    spec:
      replicas: 0
      selector:
        matchLabels:
          app: inflate
      template:
        metadata:
          labels:
            app: inflate
        spec:
          terminationGracePeriodSeconds: 0
          containers:
            - name: inflate
              image: public.ecr.aws/eks-distro/kubernetes/pause:3.7
              resources:
                requests:
                  cpu: 1
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}