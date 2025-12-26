output "argocd_admin_password" {
  value     = data.kubernetes_secret_v1.argocd_admin_password.data.password
  sensitive = true
}
