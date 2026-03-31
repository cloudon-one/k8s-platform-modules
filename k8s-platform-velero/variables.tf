variable "chart_version" {
  description = "Velero Helm chart version"
  type        = string
  default     = "12.0.0"
}

variable "namespace" {
  description = "Kubernetes namespace for Velero"
  type        = string
  default     = "velero"
}

variable "backup_storage_location" {
  description = "Backup storage location configuration"
  type        = any
  default     = {}
}

variable "volume_snapshot_location" {
  description = "Volume snapshot location configuration"
  type        = any
  default     = {}
}

variable "service_account" {
  description = "Service account configuration (IRSA)"
  type        = any
  default     = {}
}

variable "resources" {
  description = "Resource limits and requests"
  type = object({
    limits = object({
      memory = string
      cpu    = string
    })
    requests = object({
      memory = string
      cpu    = string
    })
  })
  default = {
    limits   = { memory = "512Mi", cpu = "500m" }
    requests = { memory = "256Mi", cpu = "250m" }
  }
}

variable "security_context" {
  description = "Pod security context"
  type        = any
  default     = {}
}

variable "container_security_context" {
  description = "Container security context"
  type        = any
  default     = {}
}

variable "schedules" {
  description = "Backup schedules"
  type        = any
  default     = {}
}

variable "node_agent" {
  description = "Node agent (Restic) configuration"
  type        = any
  default     = {}
}

variable "configuration" {
  description = "Velero configuration"
  type        = any
  default     = {}
}

variable "metrics" {
  description = "Metrics configuration"
  type        = any
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
