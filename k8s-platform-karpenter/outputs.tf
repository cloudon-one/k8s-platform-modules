output "service_account_role_arn" {
  description = "ARN of the IAM role used by the Karpenter service account"
  value       = aws_iam_role.karpenter_controller.arn
}

output "service_account_role_name" {
  description = "Name of the IAM role used by the Karpenter service account"
  value       = aws_iam_role.karpenter_controller.name
}

output "service_account_policy_arn" {
  description = "ARN of the IAM policy attached to the Karpenter role"
  value       = aws_iam_policy.karpenter_controller.arn
}

output "namespace" {
  description = "Kubernetes namespace where Karpenter is deployed"
  value       = helm_release.karpenter.namespace
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile used for EKS nodes"
  value       = local.instance_profile_name
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile used for EKS nodes"
  value       = local.instance_profile_arn
}

output "instance_profile_role_name" {
  description = "Name of the IAM role associated with the instance profile"
  value       = var.create_instance_profile ? aws_iam_role.eks_node.name : null
}

output "instance_profile_role_arn" {
  description = "ARN of the IAM role associated with the instance profile"
  value       = var.create_instance_profile ? aws_iam_role.eks_node.arn : null
}