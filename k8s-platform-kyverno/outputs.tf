output "namespace" {
  description = "Namespace where Kyverno is deployed"
  value       = kubernetes_namespace.kyverno.metadata[0].name
}

output "release_name" {
  description = "Name of the Helm release"
  value       = helm_release.kyverno.name
}
