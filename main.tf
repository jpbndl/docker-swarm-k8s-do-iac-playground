module "swarm_droplets" {
  source = "./modules/swarm_droplets"
  region = var.region
  droplet_size = var.droplet_size
  private_key_path = var.private_key_path
  ssh_key_id = data.digitalocean_ssh_key.docker_associate.id
}

module "project" {
  source = "./modules/project"
  droplet_urns = module.swarm_droplets.droplet_urns
}

module "kubernetes" {
  source = "./modules/kubernetes"
  region = var.region
  node_size = var.node_size
}

output "droplet_urns" {
  value = module.swarm_droplets.droplet_urns
}

output "droplet_ips" {
  value = module.swarm_droplets.droplet_ips
}