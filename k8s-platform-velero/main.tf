resource "kubernetes_namespace_v1" "velero" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "velero" {
  name       = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  version    = var.chart_version
  namespace  = kubernetes_namespace_v1.velero.metadata[0].name

  set = [
    { name = "initContainers[0].name", value = "velero-plugin-for-aws" },
    { name = "initContainers[0].image", value = "velero/velero-plugin-for-aws:v1.10.0" },
    { name = "initContainers[0].volumeMounts[0].mountPath", value = "/target" },
    { name = "initContainers[0].volumeMounts[0].name", value = "plugins" },
    { name = "configuration.backupStorageLocation[0].name", value = tostring(try(var.backup_storage_location.name, "default")) },
    { name = "configuration.backupStorageLocation[0].provider", value = tostring(try(var.backup_storage_location.provider, "aws")) },
    { name = "configuration.backupStorageLocation[0].bucket", value = tostring(try(var.backup_storage_location.bucket, "")) },
    { name = "configuration.backupStorageLocation[0].config.region", value = tostring(var.aws_region) },
    { name = "configuration.volumeSnapshotLocation[0].name", value = tostring(try(var.volume_snapshot_location.name, "default")) },
    { name = "configuration.volumeSnapshotLocation[0].provider", value = tostring(try(var.volume_snapshot_location.provider, "aws")) },
    { name = "configuration.volumeSnapshotLocation[0].config.region", value = tostring(var.aws_region) },
    { name = "serviceAccount.server.annotations.eks\\.amazonaws\\.com/role-arn", value = tostring(try(var.service_account.server.annotations["eks.amazonaws.com/role-arn"], "")) },
    { name = "resources.limits.memory", value = tostring(var.resources.limits.memory) },
    { name = "resources.limits.cpu", value = tostring(var.resources.limits.cpu) },
    { name = "resources.requests.memory", value = tostring(var.resources.requests.memory) },
    { name = "resources.requests.cpu", value = tostring(var.resources.requests.cpu) },
    { name = "metrics.enabled", value = tostring(try(var.metrics.enabled, true)) },
  ]
}
