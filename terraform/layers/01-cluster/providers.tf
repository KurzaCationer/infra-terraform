terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.51.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

provider "helm" {
  kubernetes = {
    host                   = module.cluster.kubeconfig_data.host
    client_certificate     = module.cluster.kubeconfig_data.client_certificate
    client_key             = module.cluster.kubeconfig_data.client_key
    cluster_ca_certificate = module.cluster.kubeconfig_data.cluster_ca_certificate
  }
}
