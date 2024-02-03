locals {
  node_class_name = "${local.base_tags.project}-node-class"
  node_pool_name  = "${local.base_tags.project}-node-pool"
}

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
  timeout             = 800

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
}

resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1beta1
    kind: EC2NodeClass
    metadata:
      name: ${local.node_class_name}
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
        Name: ${local.base_tags.project}-eks-node
  YAML
}

resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1beta1
    kind: NodePool
    metadata:
      name: ${local.node_pool_name}
    spec:
      template:
        spec:
          nodeClassRef:
            name: ${local.node_class_name}
          requirements:
            - key: "karpenter.k8s.aws/instance-category"
              operator: In
              values: ["t", "c", "m", "r"]
            - key: "karpenter.k8s.aws/instance-cpu"
              operator: In
              values: ["2", "4", "8", "16", "32", "64"]
            - key: "karpenter.k8s.aws/instance-memory"
              operator: In
              values: ["2048", "4096", "8192", "32768"]
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
# this will create an example deployment called inflate
# this deployment can be used to test karpeneter's auto scaling capabilities
#resource "kubectl_manifest" "karpenter_example_deployment" {
#  yaml_body = <<-YAML
#    apiVersion: apps/v1
#    kind: Deployment
#    metadata:
#      name: inflate
#    spec:
#      replicas: 0
#      selector:
#        matchLabels:
#          app: inflate
#      template:
#        metadata:
#          labels:
#            app: inflate
#        spec:
#          terminationGracePeriodSeconds: 0
#          containers:
#            - name: inflate
#              image: public.ecr.aws/eks-distro/kubernetes/pause:3.7
#              resources:
#                requests:
#                  cpu: 1
#  YAML
#
#  depends_on = [
#    helm_release.karpenter
#  ]
#}
