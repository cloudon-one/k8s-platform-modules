resource "kubernetes_namespace_v1" "atlantis" {
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
  namespace  = kubernetes_namespace_v1.atlantis.metadata[0].name

  set = concat(
    [
      { name = "orgWhitelist", value = join(",", var.org_whitelist) },
      { name = "atlantisUrl", value = var.webhook_url },
      { name = "ingress.enabled", value = "true" },
      { name = "ingress.host", value = var.ingress_host },
      { name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn", value = var.iam_role_arn },
    ],
    [for k, v in var.ingress_annotations : {
      name  = "ingress.annotations.${replace(k, ".", "\\.")}"
      value = v
    }]
  )

  set_sensitive = [
    { name = "github.token", value = var.github_token },
    { name = "github.secret", value = var.github_webhook_secret },
  ]
}
