data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = data.aws_eks_cluster.cluster.endpoint
}