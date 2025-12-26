variable "cloudflare_zone_id" {
  description = "The Zone ID in Cloudflare where DNS records will be created."
  type        = string
  sensitive   = true
}

variable "data_plane_ip" {
  description = "Object containing the IPv4 and IPv6 addresses of the data plane (Load Balancer/Ingress)."
  type = object({
    ipv4 = optional(string)
    ipv6 = string
  })
}

variable "data_plane_domain_names" {
  description = "Set of domain names (hostnames) to point to the data plane IP addresses."
  type        = set(string)
}
