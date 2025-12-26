terraform {
  required_version = ">= 1.5.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.51.0"
    }
  }
}

module "kube-hetzner" {
  source  = "kube-hetzner/kube-hetzner/hcloud"
  version = "2.18.4"
  providers = {
    hcloud = hcloud
  }
  hcloud_token = var.hetzner_hcloud_token

  cluster_name = var.cluster_name

  # Configuration
  hetzner_ccm_use_helm              = true
  enable_klipper_metal_lb           = true
  allow_scheduling_on_control_plane = true
  automatically_upgrade_k3s         = false
  system_upgrade_use_drain          = true
  automatically_upgrade_os          = false
  create_kubeconfig                 = var.create_kubeconfig

  dns_servers = var.dns_servers

  ssh_port        = var.ssh_port
  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key

  firewall_ssh_source            = var.firewall_ssh_source
  firewall_kube_api_source       = var.firewall_kube_api_source
  traefik_additional_trusted_ips = var.ingress_additional_trusted_ips
  traefik_additional_ports       = var.ingress_additional_ports
  extra_firewall_rules           = var.firewall_extra_rules

  additional_tls_sans       = [var.control_plane_address]
  kubeconfig_server_address = var.control_plane_address

  network_region = "eu-central"

  control_plane_nodepools = [
    {
      name        = "control-plane-nbg1",
      server_type = "cpx32",
      location    = "nbg1",
      labels      = [],
      taints      = [],
      count       = 1
    },
  ]
  agent_nodepools = []
}
