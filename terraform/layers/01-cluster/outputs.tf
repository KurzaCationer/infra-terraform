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

output "argo_cd_admin_password" {
  value = random_password.argo_cd_admin_password.result
  sensitive = true
}
