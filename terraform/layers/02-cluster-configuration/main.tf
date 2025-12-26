resource "argocd_application" "infra" {
  depends_on = [kubernetes_secret_v1.gha_arc_mijke, kubernetes_secret_v1.gha_arc_personal]
  metadata {
    name      = "infra"
    namespace = "argocd"
  }

  cascade = true
  wait    = true

  spec {
    project = "default"
    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }
    source {
      repo_url        = "https://github.com/KurzaCationer/infra-argocd.git"
      target_revision = "main"
      path            = "manifests"
      directory {
        recurse = true
        include = "*.yaml"
      }
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }
  }
}

resource "kubernetes_namespace_v1" "gha_arc_personal" {
  metadata {
    name = "gha-arc-runners-personal"
  }
}

resource "kubernetes_secret_v1" "gha_arc_personal" {
  metadata {
    name      = "gha-arc-personal"
    namespace = kubernetes_namespace_v1.gha_arc_personal.metadata[0].name
  }
  type = "Opaque"
  data = {
    github_token = var.github_gha_runner_controller_pat_personal
  }
}

resource "kubernetes_namespace_v1" "gha_arc_mijke" {
  metadata {
    name = "gha-arc-runners-mijke"
  }
}

resource "kubernetes_secret_v1" "gha_arc_mijke" {
  metadata {
    name      = "gha-arc-mijke"
    namespace = kubernetes_namespace_v1.gha_arc_mijke.metadata[0].name
  }
  type = "Opaque"
  data = {
    github_token = var.github_gha_runner_controller_pat_mijke
  }
}
