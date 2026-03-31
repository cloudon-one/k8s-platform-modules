variable "chart_version" {
  description = "Kyverno Helm chart version"
  type        = string
  default     = "3.7.1"
}

variable "namespace" {
  description = "Kubernetes namespace for Kyverno"
  type        = string
  default     = "kyverno"
}

variable "replica_count" {
  description = "Number of Kyverno replicas"
  type        = number
  default     = 3
}

variable "background_controller_replicas" {
  description = "Background controller replica count"
  type        = number
  default     = 2
}

variable "reports_controller_replicas" {
  description = "Reports controller replica count"
  type        = number
  default     = 2
}

variable "admission_controller_replicas" {
  description = "Admission controller replica count"
  type        = number
  default     = 3
}

variable "pod_security_standard" {
  description = "Pod security standard level"
  type        = string
  default     = "restricted"
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

variable "pod_disruption_budget" {
  description = "Pod disruption budget settings"
  type = object({
    enabled       = bool
    min_available = number
  })
  default = { enabled = true, min_available = 1 }
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

variable "policies" {
  description = "Kyverno policies to deploy"
  type        = any
  default     = {}
}

variable "network_policies" {
  description = "Network policy settings"
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

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
