variable "cloudflare_token" {
  type = string
  sensitive = true
}

variable "cert_manager_acme_email" {
  type = string
  sensitive = true
}

variable "github_gha_runner_controller_pat_mijke" {
  type = string
  sensitive = true
}

variable "github_gha_runner_controller_pat_personal" {
  type = string
  sensitive = true
}