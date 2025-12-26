data "external" "current_ipv4" {
  program = ["bash", "../../scripts/utilities/retrieve_current_ip.sh", "--ipv4"]
}

data "external" "current_ipv6" {
  program = ["bash", "../../scripts/utilities/retrieve_current_ip.sh", "--ipv6"]
}

locals {
  safe_source_urls = concat(
    data.external.current_ipv4.result.ip != "" ? ["${chomp(data.external.current_ipv4.result.ip)}/32"] : [],
    data.external.current_ipv6.result.ip != "" ? ["${chomp(data.external.current_ipv6.result.ip)}/128"] : [],
  )
}

data "http" "cloudflare_source_ips" {
  url = "https://api.cloudflare.com/client/v4/ips"
}

locals {
  cloudflare_source_ips_json = jsondecode(data.http.cloudflare_source_ips.response_body)
  cloudflare_source_ips = concat(local.cloudflare_source_ips_json.result.ipv4_cidrs, local.cloudflare_source_ips_json.result.ipv6_cidrs)
}

module "cluster" {
  source = "../../modules/cluster"
  providers = {
    hcloud = hcloud
  }
  hetzner_hcloud_token  = var.hcloud_token

  cluster_name          = "infra"
  control_plane_address = coalesce(module.cluster.control_plane_ip.ipv4, module.cluster.control_plane_ip.ipv6)

  dns_servers = ["9.9.9.11", "149.112.112.11", "2620:fe::11"]

  firewall_kube_api_source       = local.safe_source_urls
  firewall_ssh_source            = local.safe_source_urls
  ingress_additional_trusted_ips = local.cloudflare_source_ips

  ssh_private_key = file("../../secrets/ssh.private")
  ssh_public_key  = file("../../secrets/ssh.public")
  ssh_port        = 55558

  create_kubeconfig = var.create_kubeconfig
}

module "argo" {
  source = "../../modules/argo"
}

locals {
  cloudflare_zone_ids = toset([
    "ba552fa5fbf14058b187ed804de62161",
    "a1b67a7278977072d9713fd6108911a4"
  ])
}

module "dns" {
  source   = "../../modules/dns"
  for_each = local.cloudflare_zone_ids

  cloudflare_zone_id      = each.value
  data_plane_domain_names = ["*", "@"]
  data_plane_ip           = module.cluster.data_plane_ip
}