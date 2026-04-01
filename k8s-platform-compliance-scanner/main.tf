resource "kubernetes_namespace_v1" "compliance_scanner" {
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
  namespace  = kubernetes_namespace_v1.compliance_scanner.metadata[0].name

  set = [
    { name = "cronjob.schedule", value = tostring(var.scan_schedule) },
    { name = "resources.limits.memory", value = tostring(var.resources.limits.memory) },
    { name = "resources.limits.cpu", value = tostring(var.resources.limits.cpu) },
    { name = "resources.requests.memory", value = tostring(var.resources.requests.memory) },
    { name = "resources.requests.cpu", value = tostring(var.resources.requests.cpu) },
    { name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn", value = tostring(try(var.service_account.annotations["eks.amazonaws.com/role-arn"], "")) },
  ]
}
