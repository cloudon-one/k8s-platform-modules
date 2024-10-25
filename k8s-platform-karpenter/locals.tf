locals {
  name              = var.name
  service_account   = var.service_account_name
  namespace         = var.namespace

  partition         = data.aws_partition.current.partition
  account_id        = data.aws_caller_identity.current.account_id
  oidc_provider     = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  cluster_endpoint  = data.aws_eks_cluster.cluster.endpoint
  instance_profile_name = coalesce(var.cluster_instance_profile, aws_iam_instance_profile.eks_node.name)
  instance_profile_arn  = var.cluster_instance_profile != null ? data.aws_iam_instance_profile.existing[0].arn : aws_iam_instance_profile.eks_node.arn
}
