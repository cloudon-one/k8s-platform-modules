output "argocd_namespace" {
  description = "Namespace where ArgoCD is installed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_server_service" {
  description = "Name of the ArgoCD server service"
  value       = "${helm_release.argocd.name}-server"
}

output "iam_role_arn" {
  description = "ARN of the IAM role created for ArgoCD"
  value       = aws_iam_role.argocd.arn
}

output "monitoring_enabled" {
  description = "Whether monitoring is enabled for ArgoCD"
  value       = var.enable_monitoring
}

output "prometheus_rules" {
  description = "Name of the PrometheusRules resource"
  value       = var.enable_monitoring ? kubernetes_manifest.argocd_prometheusrule[0].manifest.metadata.name : null
}

output "grafana_dashboard" {
  description = "Name of the Grafana dashboard ConfigMap"
  value       = var.enable_monitoring ? kubernetes_config_map.argocd_dashboard[0].metadata[0].name : null
}

output "configured_repositories" {
  description = "List of configured repository names"
  value       = [for repo in kubernetes_manifest.repository : repo.manifest.metadata.name]
}

output "github_apps" {
  description = "List of configured GitHub App IDs"
  value       = [for app in kubernetes_secret.github_app_credentials : app.data.id]
}