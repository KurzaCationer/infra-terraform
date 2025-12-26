output "kubeconfig_data" {
  value     = module.cluster.kubeconfig_data
  sensitive = true
}

output "kubeconfig" {
  value     = module.cluster.kubeconfig
  sensitive = true
}

output "data_plane_ip" {
  value = module.cluster.data_plane_ip
}
