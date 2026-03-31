output "namespace" {
  description = "Namespace where Loki is deployed"
  value       = kubernetes_namespace.loki.metadata[0].name
}

output "release_name" {
  description = "Name of the Helm release"
  value       = helm_release.loki.name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for Loki storage"
  value       = var.create_s3_bucket ? aws_s3_bucket.loki[0].id : var.s3_bucket_name
}

output "iam_role_arn" {
  description = "ARN of the IAM role for Loki"
  value       = var.create_iam_resources ? aws_iam_role.loki[0].arn : null
}

output "service_account_name" {
  description = "Name of the Loki service account"
  value       = kubernetes_service_account.loki.metadata[0].name
}
