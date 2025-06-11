resource "digitalocean_project_resources" "docker_associate" {
  project   = "docker-associate"
  resources = var.droplet_urns
}