variable "chart_version" {
  description = "Compliance scanner Helm chart version"
  type        = string
  default     = "1.2.0"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "compliance-scanner"
}

variable "scan_schedule" {
  description = "CIS scan cron schedule"
  type        = string
  default     = "0 3 * * 1"
}

variable "benchmark_version" {
  description = "CIS benchmark version"
  type        = string
  default     = "cis-1.8"
}

variable "targets" {
  description = "Target types to scan"
  type        = list(string)
  default     = ["master", "node", "etcd", "policies"]
}

variable "results" {
  description = "Results storage configuration"
  type        = any
  default     = {}
}

variable "reports" {
  description = "Report generation configuration"
  type        = any
  default     = {}
}

variable "cloudwatch" {
  description = "CloudWatch integration"
  type        = any
  default     = {}
}

variable "notifications" {
  description = "SNS notification configuration"
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
