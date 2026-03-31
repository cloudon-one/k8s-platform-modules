resource "kubernetes_namespace" "velero" {
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
  namespace  = kubernetes_namespace.velero.metadata[0].name

  set {
    name  = "initContainers[0].name"
    value = "velero-plugin-for-aws"
  }

  set {
    name  = "initContainers[0].image"
    value = "velero/velero-plugin-for-aws:v1.10.0"
  }

  set {
    name  = "initContainers[0].volumeMounts[0].mountPath"
    value = "/target"
  }

  set {
    name  = "initContainers[0].volumeMounts[0].name"
    value = "plugins"
  }

  set {
    name  = "configuration.backupStorageLocation[0].name"
    value = try(var.backup_storage_location.name, "default")
  }

  set {
    name  = "configuration.backupStorageLocation[0].provider"
    value = try(var.backup_storage_location.provider, "aws")
  }

  set {
    name  = "configuration.backupStorageLocation[0].bucket"
    value = try(var.backup_storage_location.bucket, "")
  }

  set {
    name  = "configuration.backupStorageLocation[0].config.region"
    value = var.aws_region
  }

  set {
    name  = "configuration.volumeSnapshotLocation[0].name"
    value = try(var.volume_snapshot_location.name, "default")
  }

  set {
    name  = "configuration.volumeSnapshotLocation[0].provider"
    value = try(var.volume_snapshot_location.provider, "aws")
  }

  set {
    name  = "configuration.volumeSnapshotLocation[0].config.region"
    value = var.aws_region
  }

  set {
    name  = "serviceAccount.server.annotations.eks\\.amazonaws\\.com/role-arn"
    value = try(var.service_account.server.annotations["eks.amazonaws.com/role-arn"], "")
  }

  set {
    name  = "resources.limits.memory"
    value = var.resources.limits.memory
  }

  set {
    name  = "resources.limits.cpu"
    value = var.resources.limits.cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.resources.requests.memory
  }

  set {
    name  = "resources.requests.cpu"
    value = var.resources.requests.cpu
  }

  set {
    name  = "metrics.enabled"
    value = tostring(try(var.metrics.enabled, true))
  }
}
