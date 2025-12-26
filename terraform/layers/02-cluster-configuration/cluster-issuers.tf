locals {
  cf_api_token_key = "token"
}

resource "kubernetes_secret_v1" "cluster_issuer_cf_dns_token" {
  metadata {
    name = "cf-dns-token"
  }
  type = "Opaque"
  data = {
    (local.cf_api_token_key) = var.cloudflare_token
  }
}

resource "kubernetes_manifest" "cluster_issuer_lets_encrypt_staging" {
  manifest = {
    apiVersion = "cert-manager.io/v1",
    kind       = "ClusterIssuer"
    metadata = {
      name = "le-staging"
    }
    spec = {
      acme = {
        server = "https://acme-staging-v02.api.letsencrypt.org/directory",
        email  = var.cert_manager_acme_email,
        privateKeySecretRef = {
          name = "le-staging-private-key"
        }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                apiTokenSecretRef = {
                  name = kubernetes_secret_v1.cluster_issuer_cf_dns_token.metadata[0].name
                  key = local.cf_api_token_key
                }
              }
            }
          }
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "cluster_issuer_lets_encrypt_prod" {
  manifest = {
    apiVersion = "cert-manager.io/v1",
    kind       = "ClusterIssuer"
    metadata = {
      name = "le"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory",
        email  = var.cert_manager_acme_email,
        privateKeySecretRef = {
          name = "le-private-key"
        }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                apiTokenSecretRef = {
                  name = kubernetes_secret_v1.cluster_issuer_cf_dns_token.metadata[0].name
                  key = local.cf_api_token_key
                }
              }
            }
          }
        ]
      }
    }
  }
}