variable "name" {
  description = "Name for the Karpenter deployment"
  type        = string
  default     = "karpenter"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy Karpenter"
  type        = string
  default     = "karpenter"
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account for Karpenter"
  type        = string
  default     = "karpenter"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

#variable "cluster_endpoint" {
#  description = "The EKS cluster endpoint URL. Must be a valid HTTPS endpoint (e.g., https://1234567890ABCDEF.gr7.us-west-2.eks.amazonaws.com)"
#  type        = string
#
#  validation {
#    condition     = can(regex("^https://[a-zA-Z0-9-]+\\.[a-zA-Z0-9-]+\\.[a-zA-Z0-9-]+\\.eks\\.amazonaws\\.com$", var.cluster_endpoint))
#    error_message = "The cluster_endpoint must be a valid EKS endpoint URL starting with https:// and ending with .eks.amazonaws.com"
#  }
#}

# Optional: Allow overriding the endpoint if using data source
variable "cluster_endpoint_override" {
  description = "Optional override for cluster endpoint. If not provided, the endpoint will be fetched from the EKS cluster data source"
  type        = string
  default     = null
}

variable "cluster_oidc_provider" {
  description = "OIDC provider of the EKS cluster (without https://)"
  type        = string
}

variable "cluster_node_role_arn" {
  description = "ARN of the EKS node IAM role"
  type        = string
}

variable "cluster_instance_profile" {
  description = "Name of the IAM instance profile for the EKS nodes"
  type        = string
}

variable "karpenter_version" {
  description = "Version of Karpenter to deploy"
  type        = string
  default     = "v0.33.0"
}

variable "helm_values" {
  description = "Additional Helm values for Karpenter deployment"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

#variable "create_instance_profile" {
#  description = "Whether to create a new instance profile. If false, cluster_instance_profile must be provided."
#  type        = bool
#  default     = true
#}

#variable "instance_profile_path" {
#  description = "Path for the instance profile"
#  type        = string
#  default     = "/"
#}

# Optional: Additional policies to attach to the instance profile role
variable "additional_instance_profile_policies" {
  description = "List of additional IAM policy ARNs to attach to the instance profile role"
  type        = list(string)
  default     = []
}