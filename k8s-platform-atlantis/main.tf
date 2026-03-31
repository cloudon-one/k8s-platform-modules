resource "kubernetes_namespace" "atlantis" {
  metadata {
    name   = var.namespace
    labels = var.namespace_labels
  }
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  chart      = "atlantis"
  version    = var.chart_version
  namespace  = kubernetes_namespace.atlantis.metadata[0].name

  set {
    name  = "orgWhitelist"
    value = join(",", var.org_whitelist)
  }

  set_sensitive {
    name  = "github.token"
    value = var.github_token
  }

  set_sensitive {
    name  = "github.secret"
    value = var.github_webhook_secret
  }

  set {
    name  = "atlantisUrl"
    value = var.webhook_url
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.host"
    value = var.ingress_host
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.iam_role_arn
  }

  dynamic "set" {
    for_each = var.ingress_annotations
    content {
      name  = "ingress.annotations.${replace(set.key, ".", "\\.")}"
      value = set.value
    }
  }
}
