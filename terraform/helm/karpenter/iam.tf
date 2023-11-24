#resource "aws_iam_openid_connect_provider" "eks" {
#  client_id_list  = ["sts.amazonaws.com"]
#  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
#  url             = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
#}

data "aws_iam_policy_document" "karpenter_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }

    principals {
      identifiers = [data.aws_ssm_parameter.eks_oidc_arn.value]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "karpenter_controller" {
  assume_role_policy = data.aws_iam_policy_document.karpenter_controller_assume_role_policy.json
  name               = "karpenter-controller"
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.karpenter_controller.arn
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile"
  role = data.aws_ssm_parameter.eks_nodegroup_role_name.value
}

resource "aws_iam_policy" "karpenter_controller" {
  name        = "karpenter-controller-policy"
  description = "karpenter-controller service account  policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateFleet",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateTags",
          "ec2:DeleteLaunchTemplate",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "iam:PassRole",
          "pricing:GetProducts",
          "ssm:GetParameter",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}