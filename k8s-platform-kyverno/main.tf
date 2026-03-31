resource "kubernetes_namespace" "kyverno" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "kyverno" {
  name       = "kyverno"
  repository = "https://kyverno.github.io/kyverno"
  chart      = "kyverno"
  version    = var.chart_version
  namespace  = kubernetes_namespace.kyverno.metadata[0].name

  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  set {
    name  = "backgroundController.replicas"
    value = var.background_controller_replicas
  }

  set {
    name  = "reportsController.replicas"
    value = var.reports_controller_replicas
  }

  set {
    name  = "admissionController.replicas"
    value = var.admission_controller_replicas
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
}

resource "kubernetes_manifest" "require_approved_registries" {
  count = try(var.policies.require_approved_registries.enabled, false) ? 1 : 0

  manifest = {
    apiVersion = "kyverno.io/v1"
    kind       = "ClusterPolicy"
    metadata = {
      name = "require-approved-registries"
    }
    spec = {
      validationFailureAction = try(var.policies.require_approved_registries.validation_failure_action, "Audit")
      background              = try(var.policies.require_approved_registries.background, true)
      rules = [
        {
          name = "validate-registries"
          match = {
            any = [{ resources = { kinds = ["Pod"] } }]
          }
          validate = {
            message = "Images must come from approved registries."
            pattern = {
              spec = {
                containers = [
                  { image = join(" | ", try(var.policies.require_approved_registries.approved_registries, [])) }
                ]
              }
            }
          }
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "require_image_tag" {
  count = try(var.policies.require_image_tag.enabled, false) ? 1 : 0

  manifest = {
    apiVersion = "kyverno.io/v1"
    kind       = "ClusterPolicy"
    metadata = {
      name = "disallow-latest-tag"
    }
    spec = {
      validationFailureAction = try(var.policies.require_image_tag.validation_failure_action, "Audit")
      background              = try(var.policies.require_image_tag.background, true)
      rules = [
        {
          name = "require-image-tag"
          match = {
            any = [{ resources = { kinds = ["Pod"] } }]
          }
          validate = {
            message = "An image tag is required and must not be 'latest'."
            pattern = {
              spec = {
                containers = [
                  { image = "!*:latest" }
                ]
              }
            }
          }
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "require_resource_limits" {
  count = try(var.policies.require_resource_limits.enabled, false) ? 1 : 0

  manifest = {
    apiVersion = "kyverno.io/v1"
    kind       = "ClusterPolicy"
    metadata = {
      name = "require-resource-limits"
    }
    spec = {
      validationFailureAction = try(var.policies.require_resource_limits.validation_failure_action, "Audit")
      background              = try(var.policies.require_resource_limits.background, true)
      rules = [
        {
          name = "validate-resources"
          match = {
            any = [{ resources = { kinds = ["Pod"] } }]
          }
          validate = {
            message = "CPU and memory resource limits are required."
            pattern = {
              spec = {
                containers = [
                  {
                    resources = {
                      limits = {
                        memory = "?*"
                        cpu    = "?*"
                      }
                    }
                  }
                ]
              }
            }
          }
        }
      ]
    }
  }
}
