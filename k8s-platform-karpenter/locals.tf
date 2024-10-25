locals {
  name              = var.name
  service_account   = var.service_account_name
  namespace         = var.namespace

  partition         = data.aws_partition.current.partition
  account_id        = data.aws_caller_identity.current.account_id
  oidc_provider     = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  cluster_endpoint  = coalesce(var.cluster_endpoint_override, data.aws_eks_cluster.cluster.endpoint)
}
