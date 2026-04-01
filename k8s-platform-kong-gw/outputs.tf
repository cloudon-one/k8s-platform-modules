output "namespace" {
  description = "Namespace where Kong is deployed"
  value       = kubernetes_namespace_v1.kong.metadata[0].name
}

output "release_name" {
  description = "Name of the Helm release"
  value       = helm_release.kong.name
}

output "security_group_id" {
  description = "ID of the Kong security group"
  value       = aws_security_group.kong.id
}

output "database_endpoint" {
  description = "Endpoint of the Kong database"
  value       = var.create_database ? aws_db_instance.kong[0].endpoint : null
}

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = var.create_database ? aws_security_group.database[0].id : null
}
