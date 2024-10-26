locals {
  name      = var.name
  namespace = var.namespace
}

data "aws_region" "current" {}

resource "kubernetes_namespace" "atlantis" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = local.namespace
    labels = merge(
      var.namespace_labels,
      {
        "app.kubernetes.io/managed-by" = "terraform"
      }
    )
  }
}

resource "kubernetes_secret" "atlantis_secrets" {
  metadata {
    name      = "${local.name}-secrets"
    namespace = local.namespace
  }

  data = {
    ATLANTIS_GH_TOKEN               = var.github_token
    ATLANTIS_GH_WEBHOOK_SECRET      = var.github_webhook_secret
    ATLANTIS_GITLAB_TOKEN           = var.gitlab_token
    ATLANTIS_GITLAB_WEBHOOK_SECRET  = var.gitlab_webhook_secret
    AWS_ACCESS_KEY_ID               = var.aws_access_key
    AWS_SECRET_ACCESS_KEY           = var.aws_secret_key
    ATLANTIS_REPO_CONFIG            = var.repo_config_json
  }

  depends_on = [kubernetes_namespace.atlantis]
}

resource "kubernetes_service_account" "atlantis" {
  metadata {
    name      = "${local.name}-sa"
    namespace = local.namespace
    annotations = merge(
      {
        "eks.amazonaws.com/role-arn" = var.iam_role_arn
      },
      var.service_account_annotations
    )
  }

  depends_on = [kubernetes_namespace.atlantis]
}

resource "helm_release" "atlantis" {
  name       = local.name
  repository = "https://runatlantis.github.io/helm-charts"
  chart      = "atlantis"
  version    = var.chart_version
  namespace  = local.namespace

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      name                  = local.name
      image_tag             = var.image_tag
      service_account_name  = kubernetes_service_account.atlantis.metadata[0].name
      resources             = jsonencode(var.resources)
      aws_region            = data.aws_region.current.name
      ingress_enabled       = var.ingress_enabled
      ingress_host          = var.ingress_host
      ingress_annotations   = jsonencode(var.ingress_annotations)
      storage_class         = var.storage_class
      storage_size          = var.storage_size
      repo_config           = var.repo_config_json
      webhook_url           = var.webhook_url
      org_whitelist         = join(",", var.org_whitelist)
    })
  ]

  depends_on = [
    kubernetes_namespace.atlantis,
    kubernetes_service_account.atlantis,
    kubernetes_secret.atlantis_secrets
  ]
}