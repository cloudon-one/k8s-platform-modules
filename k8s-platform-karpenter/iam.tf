# Create IAM Role for Service Account (IRSA)
resource "aws_iam_role" "karpenter_controller" {
  name = "${local.name}-karpenter-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:${local.partition}:iam::${local.account_id}:oidc-provider/${var.cluster_oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.cluster_oidc_provider}:aud" : "sts.amazonaws.com",
            "${var.cluster_oidc_provider}:sub" : "system:serviceaccount:${local.namespace}:${local.service_account}"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# Attach required AWS managed policies
resource "aws_iam_role_policy_attachment" "karpenter_ssm_policy" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "karpenter_ecr_policy" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Create custom policy for Karpenter
resource "aws_iam_policy" "karpenter_controller" {
  name = "${local.name}-karpenter-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "ec2:TerminateInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ec2:DeleteLaunchTemplate",
          "pricing:GetProducts"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = var.cluster_node_role_arn
      }
    ]
  })

  tags = var.tags
}

# Attach custom policy to role
resource "aws_iam_role_policy_attachment" "karpenter_controller_policy" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.karpenter_controller.arn
}