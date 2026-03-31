variable "chart_version" {
  description = "Falco Helm chart version"
  type        = string
  default     = "8.0.1"
}

variable "namespace" {
  description = "Kubernetes namespace for Falco"
  type        = string
  default     = "falco"
}

variable "driver" {
  description = "Falco driver configuration"
  type = object({
    kind    = string
    enabled = bool
  })
  default = { kind = "ebpf", enabled = true }
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
    limits   = { memory = "1Gi", cpu = "1000m" }
    requests = { memory = "512Mi", cpu = "500m" }
  }
}

variable "security_context" {
  description = "Security context for Falco pods"
  type        = any
  default     = {}
}

variable "falco_config" {
  description = "Falco configuration"
  type        = any
  default     = {}
}

variable "integrations" {
  description = "Falco integrations (CloudWatch, etc.)"
  type        = any
  default     = {}
}

variable "custom_rules" {
  description = "Custom Falco detection rules"
  type        = any
  default     = []
}

variable "service_account" {
  description = "Service account configuration"
  type        = any
  default     = {}
}

variable "tolerations" {
  description = "Pod tolerations"
  type        = any
  default     = []
}

variable "daemonset" {
  description = "DaemonSet configuration"
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

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
