variable "namespace" {
  description = "Kubernetes namespace for Atlantis"
  type        = string
  default     = "atlantis"
}

variable "chart_version" {
  description = "Atlantis Helm chart version"
  type        = string
  default     = "5.1.0"
}

variable "iam_role_arn" {
  description = "IAM role ARN for Atlantis"
  type        = string
}

variable "github_token" {
  description = "GitHub token (from Secrets Manager)"
  type        = string
  sensitive   = true
}

variable "github_webhook_secret" {
  description = "GitHub webhook secret (from Secrets Manager)"
  type        = string
  sensitive   = true
}

variable "gitlab_token" {
  description = "GitLab token (from Secrets Manager)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "gitlab_webhook_secret" {
  description = "GitLab webhook secret (from Secrets Manager)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "webhook_url" {
  description = "Atlantis webhook URL"
  type        = string
}

variable "org_whitelist" {
  description = "List of allowed GitHub organizations"
  type        = list(string)
}

variable "repo_config_json" {
  description = "Atlantis repo config JSON"
  type        = string
  default     = ""
}

variable "ingress_host" {
  description = "Hostname for Atlantis ingress"
  type        = string
}

variable "ingress_annotations" {
  description = "Annotations for ingress"
  type        = map(string)
  default     = {}
}

variable "namespace_labels" {
  description = "Labels for the namespace"
  type        = map(string)
  default     = {}
}

variable "service_account_annotations" {
  description = "Annotations for service account (IRSA)"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for AWS resources"
  type        = map(string)
  default     = {}
}
