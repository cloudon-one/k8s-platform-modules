output "namespace" {
  description = "Namespace where Atlantis is deployed"
  value       = kubernetes_namespace_v1.atlantis.metadata[0].name
}

output "release_name" {
  description = "Name of the Helm release"
  value       = helm_release.atlantis.name
}
