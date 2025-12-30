terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.15.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.17.0"
    }
  }
}

resource "cloudflare_zone" "zone" {
  for_each = var.dns_zones
  account = {
    id = var.cloudflare_account_id
  }
  name = each.key

  type = "full"
}

resource "aws_route53domains_registered_domain" "domain" {
  for_each    = cloudflare_zone.zone
  domain_name = each.key

  transfer_lock = false

  admin_privacy      = true
  billing_privacy    = true
  registrant_privacy = true
  tech_privacy       = true

  admin_contact {
    contact_type   = var.contact_information.contact_type
    first_name     = var.contact_information.first_name
    last_name      = var.contact_information.last_name
    email          = var.contact_information.email
    phone_number   = var.contact_information.phone_number
    address_line_1 = var.contact_information.address_line_1
    country_code   = var.contact_information.country_code
    city           = var.contact_information.city
    zip_code       = var.contact_information.zip_code
  }

  billing_contact {
    contact_type   = var.contact_information.contact_type
    first_name     = var.contact_information.first_name
    last_name      = var.contact_information.last_name
    email          = var.contact_information.email
    phone_number   = var.contact_information.phone_number
    address_line_1 = var.contact_information.address_line_1
    country_code   = var.contact_information.country_code
    city           = var.contact_information.city
    zip_code       = var.contact_information.zip_code
  }

  registrant_contact {
    contact_type   = var.contact_information.contact_type
    first_name     = var.contact_information.first_name
    last_name      = var.contact_information.last_name
    email          = var.contact_information.email
    phone_number   = var.contact_information.phone_number
    address_line_1 = var.contact_information.address_line_1
    country_code   = var.contact_information.country_code
    city           = var.contact_information.city
    zip_code       = var.contact_information.zip_code
  }

  tech_contact {
    contact_type   = var.contact_information.contact_type
    first_name     = var.contact_information.first_name
    last_name      = var.contact_information.last_name
    email          = var.contact_information.email
    phone_number   = var.contact_information.phone_number
    address_line_1 = var.contact_information.address_line_1
    country_code   = var.contact_information.country_code
    city           = var.contact_information.city
    zip_code       = var.contact_information.zip_code
  }

  dynamic "name_server" {
    for_each = each.value.name_servers
    content {
      name = name_server.value
    }
  }
}

resource "cloudflare_dns_record" "cloudflare_dns_lb_ipv4" {
  for_each = {
    for item in flatten([
      for domain, recordNames in var.dns_zones : [
        for recordName in recordNames : {
          zone_id     = cloudflare_zone.zone[domain].id
          domain      = domain
          record_name = recordName
        }
      ]
    ]) : "${item.domain}_${item.record_name}" => item
  }
  zone_id = each.value.zone_id
  name    = each.value.record_name
  ttl     = 1
  type    = "A"
  content = var.data_plane_ip.ipv4
  proxied = true
}

resource "cloudflare_dns_record" "cloudflare_dns_lb_ipv6" {
  for_each = {
    for item in flatten([
      for domain, recordNames in var.dns_zones : [
        for recordName in recordNames : {
          zone_id     = cloudflare_zone.zone[domain].id
          domain      = domain
          record_name = recordName
        }
      ]
    ]) : "${item.domain}_${item.record_name}" => item
  }
  zone_id = each.value.zone_id
  name    = each.value.record_name
  ttl     = 1
  type    = "AAAA"
  content = var.data_plane_ip.ipv6
  proxied = true
}
