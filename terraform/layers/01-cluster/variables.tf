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
  type        = bool
  default     = false
}

variable "domain_contact_information" {
  sensitive = true
  type = object({
    contact_type   = string
    first_name     = string
    last_name      = string
    email          = string
    phone_number   = string
    address_line_1 = string
    country_code   = string
    city           = string
    zip_code       = string
  })
}
