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
  type        = "dev-eks-cluster"
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
