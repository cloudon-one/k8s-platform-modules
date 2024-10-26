output "namespace" {
  description = "The namespace where Vault is deployed"
  value       = local.namespace
}

output "release_name" {
  description = "The name of the Helm release"
  value       = helm_release.vault.name
}

output "service_name" {
  description = "The name of the Vault service"
  value       = "${helm_release.vault.name}-vault"
}