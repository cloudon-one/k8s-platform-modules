resource "kubernetes_namespace" "compliance_scanner" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "compliance_scanner" {
  name       = "compliance-scanner"
  repository = "https://aquasecurity.github.io/helm-charts"
  chart      = "kube-bench"
  version    = var.chart_version
  namespace  = kubernetes_namespace.compliance_scanner.metadata[0].name

  set {
    name  = "cronjob.schedule"
    value = var.scan_schedule
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
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = try(var.service_account.annotations["eks.amazonaws.com/role-arn"], "")
  }
}
