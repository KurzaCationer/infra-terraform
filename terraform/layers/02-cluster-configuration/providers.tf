terraform {
  backend "s3" {
    bucket  = "kurza-infra-tf-state"
    key     = "02-cluster-configuration.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = ">= 7.12.4"
    }
  }
}

data "terraform_remote_state" "cluster" {
  backend = "s3"

  config = {
    bucket = "kurza-infra-tf-state"
    key    = "01-cluster.tfstate"
    region = "eu-central-1"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.kubeconfig_data.host
  client_certificate     = data.terraform_remote_state.cluster.outputs.kubeconfig_data.client_certificate
  client_key             = data.terraform_remote_state.cluster.outputs.kubeconfig_data.client_key
  cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.kubeconfig_data.cluster_ca_certificate
}

data "kubernetes_secret_v1" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}

provider "argocd" {
  username     = "admin"
  password     = data.kubernetes_secret_v1.argocd_admin_password.data.password
  port_forward = true
  plain_text   = true
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.kubeconfig_data.host
    client_certificate     = data.terraform_remote_state.cluster.outputs.kubeconfig_data.client_certificate
    client_key             = data.terraform_remote_state.cluster.outputs.kubeconfig_data.client_key
    cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.kubeconfig_data.cluster_ca_certificate
  }
}
