data "aws_vpc" "selected" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Name = "private-subnet"
  }
}

# EKS Node Group Data
data "aws_iam_policy" "eks_nodegroup_ecr_policy" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "eks_nodegroup_eksworker_policy" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "eks_nodegroup_cni_policy" {
  name = "AmazonEKS_CNI_Policy"
}

data "aws_iam_policy_document" "eks_nodegroup_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "eks_cluster_policy" {
  name = "AmazonEKSClusterPolicy"
}

data "aws_iam_policy_document" "eks_cluster_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# EKS Fargate Profile Data
data "aws_iam_policy_document" "eks_fargate_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "fargate_policy" {
  name = "AmazonEKSFargatePodExecutionRolePolicy"
}
