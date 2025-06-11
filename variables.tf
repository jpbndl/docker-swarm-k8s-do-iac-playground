variable "digitalocean_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "region" {
  default = "sgp1"
}

variable "droplet_size" {
  default = "s-1vcpu-1gb"
}

variable "node_size" {
  default = "s-2vcpu-2gb"
}

variable "private_key_path" {
  default     = "~/.ssh/docker-associate"
  description = "Path to the private SSH key used for provisioner"
  type        = string
}

