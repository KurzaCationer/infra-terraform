resource "argocd_application" "infra" {
  metadata {
    name = "infra-argocd"
    namespace = "argocd"
  }

  cascade = true

  spec {
    project = "default"
    sync_policy {
      automated {}
    }
    source {
      repo_url = "https://github.com/KurzaCationer/infra-argocd.git"
      target_revision = "main"
      directory {
        recurse = true
        include = "*.yaml"
      }
    }
    destination {
      server = "https://kubernetes.default.svc"
      namespace = "argocd"
    }
  }
}