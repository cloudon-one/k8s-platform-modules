resource "kubernetes_namespace" "falco" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "falco" {
  name       = "falco"
  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco"
  version    = var.chart_version
  namespace  = kubernetes_namespace.falco.metadata[0].name

  set {
    name  = "driver.kind"
    value = var.driver.kind
  }

  set {
    name  = "driver.enabled"
    value = tostring(var.driver.enabled)
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
    name  = "falco.json_output"
    value = "true"
  }

  set {
    name  = "falco.log_stderr"
    value = "true"
  }

  set {
    name  = "falco.log_level"
    value = "info"
  }
}
