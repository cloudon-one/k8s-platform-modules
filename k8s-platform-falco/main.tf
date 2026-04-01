resource "kubernetes_namespace_v1" "falco" {
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
  namespace  = kubernetes_namespace_v1.falco.metadata[0].name

  set = [
    { name = "driver.kind", value = tostring(var.driver.kind) },
    { name = "driver.enabled", value = tostring(var.driver.enabled) },
    { name = "resources.limits.memory", value = tostring(var.resources.limits.memory) },
    { name = "resources.limits.cpu", value = tostring(var.resources.limits.cpu) },
    { name = "resources.requests.memory", value = tostring(var.resources.requests.memory) },
    { name = "resources.requests.cpu", value = tostring(var.resources.requests.cpu) },
    { name = "falco.json_output", value = "true" },
    { name = "falco.log_stderr", value = "true" },
    { name = "falco.log_level", value = "info" },
  ]
}
