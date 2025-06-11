output "droplet_urns" {
  value = digitalocean_droplet.swarm[*].urn
}

output "droplet_ips" {
  value = digitalocean_droplet.swarm[*].ipv4_address
}