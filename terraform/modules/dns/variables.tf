variable "cloudflare_account_id" {
  description = "The Account ID where the zones will be created"
  type        = string
  sensitive   = true
}

variable "dns_zones" {
  description = "The Zones and records that should be created"
  type        = map(list(string))
}

variable "data_plane_ip" {
  description = "Object containing the IPv4 and IPv6 addresses of the data plane (Load Balancer/Ingress)."
  type = object({
    ipv4 = optional(string)
    ipv6 = string
  })
}

variable "contact_information" {
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
