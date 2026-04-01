output "namespace" {
  description = "Namespace where Falco is deployed"
  value       = kubernetes_namespace_v1.falco.metadata[0].name
}

output "release_name" {
  description = "Name of the Helm release"
  value       = helm_release.falco.name
}
