terraform {
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
  backend = "local"

  config = {
    path = "../01-cluster/terraform.tfstate"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.kubeconfig_data.host
  client_certificate     = data.terraform_remote_state.cluster.outputs.kubeconfig_data.client_certificate
  client_key             = data.terraform_remote_state.cluster.outputs.kubeconfig_data.client_key
  cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.kubeconfig_data.cluster_ca_certificate
}

provider "argocd" {
  username = "admin"
  password = data.terraform_remote_state.cluster.outputs.argo_cd_admin_password
  port_forward = true
  plain_text = true
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.kubeconfig_data.host
    client_certificate     = data.terraform_remote_state.cluster.outputs.kubeconfig_data.client_certificate
    client_key             = data.terraform_remote_state.cluster.outputs.kubeconfig_data.client_key
    cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.kubeconfig_data.cluster_ca_certificate
  }
}
