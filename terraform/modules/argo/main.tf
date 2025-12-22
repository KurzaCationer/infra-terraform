terraform {
  required_version = ">= 1.5.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}

resource "helm_release" "helm_argocd" {
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "9.1.3"
  name       = "argocd"
  namespace  = "argocd"

  create_namespace = true
  wait             = true

  values = [
    yamlencode({
      global = {
        domain = var.argocd_domain
      }
      configs = {
        params = {
          "server.insecure" = true
        }
        secret = {
          argocdServerAdminPassword = var.hashed_admin_password
        }
      }
      server = {
        ingress = {
          enabled          = true
          ingressClassName = var.ingress_class_name
          annotations = {
            "cert-manager.io/cluster-issuer" = var.cert_manager_cluster_issuer
          }
          tls = true
        }
      }
    })
  ]
}
