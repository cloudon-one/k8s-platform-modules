# Create IAM role for the EKS nodes
resource "aws_iam_role" "eks_node" {
  name = "${var.eks_cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Attach required managed policies for EKS nodes
resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])

  policy_arn = each.value
  role       = aws_iam_role.eks_node.name
}

# Create the instance profile
resource "aws_iam_instance_profile" "eks_node" {
  name = "${var.eks_cluster_name}-node-profile"
  role = aws_iam_role.eks_node.name

  tags = var.tags
}

# Data source to get existing instance profile if provided
data "aws_iam_instance_profile" "existing" {
  count = var.cluster_instance_profile != null ? 1 : 0
  name  = var.cluster_instance_profile
}
