output "namespace" {
  description = "Namespace where Velero is deployed"
  value       = kubernetes_namespace.velero.metadata[0].name
}

output "release_name" {
  description = "Name of the Helm release"
  value       = helm_release.velero.name
}
