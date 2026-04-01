output "namespace" {
  description = "Namespace where compliance scanner is deployed"
  value       = kubernetes_namespace_v1.compliance_scanner.metadata[0].name
}

output "release_name" {
  description = "Name of the Helm release"
  value       = helm_release.compliance_scanner.name
}
