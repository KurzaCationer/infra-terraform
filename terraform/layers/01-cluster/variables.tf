variable "hcloud_token" {
  description = "The API Token for Hetzner Cloud, used to provision and manage cluster infrastructure."
  type        = string
  sensitive   = true
}

variable "cloudflare_token" {
  description = "The API Token for Cloudflare, used for managing DNS records and challenges."
  type        = string
  sensitive   = true
}

variable "create_kubeconfig" {
  description = "Whether to create file containing kubeconfig"
  type = bool
  default = false
}