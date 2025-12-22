output "kubeconfig" {
  value     = module.kube-hetzner.kubeconfig
  sensitive = true
}

output "kubeconfig_data" {
  value     = module.kube-hetzner.kubeconfig_data
  sensitive = true
}

output "control_plane_ip" {
  value = {
    ipv4 = coalesce(module.kube-hetzner.lb_control_plane_ipv4, one(module.kube-hetzner.control_planes_public_ipv4))
    ipv6 = coalesce(module.kube-hetzner.lb_control_plane_ipv6, one(module.kube-hetzner.control_planes_public_ipv6))
  }
}

output "data_plane_ip" {
  value = {
    ipv4 = module.kube-hetzner.ingress_public_ipv4
    ipv6 = module.kube-hetzner.ingress_public_ipv6
  }
}
