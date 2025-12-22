terraform {
  required_version = ">= 1.5.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

resource "cloudflare_dns_record" "cloudflare_dns_lb_ipv4" {
  for_each = var.data_plane_domain_names
  zone_id  = var.cloudflare_zone_id
  name     = each.value
  ttl      = 1
  type     = "A"
  content  = var.data_plane_ip.ipv4
  proxied  = true
}

resource "cloudflare_dns_record" "cloudflare_dns_lb_ipv6" {
  for_each = var.data_plane_domain_names
  zone_id  = var.cloudflare_zone_id
  name     = each.value
  ttl      = 1
  type     = "AAAA"
  content  = var.data_plane_ip.ipv6
  proxied  = true
}
