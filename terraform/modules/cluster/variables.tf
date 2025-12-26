variable "hetzner_hcloud_token" {
  description = "The Hetzner Cloud API Token required to provision cluster resources."
  type        = string
  sensitive   = true
}

variable "ssh_port" {
  description = "The port number to configure for SSH access on the nodes."
  type        = number
  sensitive   = true
  default     = 22
}

variable "ssh_public_key" {
  description = "The public SSH key to inject into the nodes for access."
  type        = string
}

variable "ssh_private_key" {
  description = "The private SSH key used for machine-to-machine operations (e.g., k3s installation)."
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
}

variable "firewall_kube_api_source" {
  description = "List of source CIDRs allowed to access the Kubernetes API server."
  type        = list(string)
  default     = null
}

variable "firewall_ssh_source" {
  description = "List of source CIDRs allowed to establish SSH connections to the nodes."
  type        = list(string)
  default     = null
}

variable "firewall_extra_rules" {
  description = "Additional firewall rules to apply to the cluster."
  type = list(object({
    description     = string
    direction       = string
    protocol        = string
    port            = string
    source_ips      = list(string)
    destination_ips = list(string)
  }))
  default = []
}

variable "control_plane_address" {
  description = "The public IP address (IPv4 or IPv6) of the control plane, used for TLS SANs and kubeconfig."
  type        = string
}

variable "ingress_additional_trusted_ips" {
  description = "List of trusted source IPs (e.g., Cloudflare ranges) to be trusted by the Ingress Controller."
  type        = list(string)
  default     = []
}

variable "ingress_additional_ports" {
  description = "List of additional ports to open on the Ingress Controller/Load Balancer."
  type = list(object({
    name        = string
    port        = number
    exposedPort = number
  }))
  default = []
}

variable "dns_servers" {
  description = "List of DNS servers to configure on the nodes."
  type        = list(string)
  default     = []
}

variable "create_kubeconfig" {
  type = bool
}
