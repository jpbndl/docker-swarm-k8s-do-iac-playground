resource "digitalocean_droplet" "swarm" {
  count    = 3
  image    = "centos-stream-9-x64"
  name     = "swarm-${count.index + 1}"
  region   = var.region
  size     = var.droplet_size
  backups  = false
  ssh_keys = [var.ssh_key_id]
}

# 2.a Initialize swarm only on manager (droplet 0)
resource "null_resource" "swarm_init" {
  depends_on = [digitalocean_droplet.swarm]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.private_key_path)
    host        = digitalocean_droplet.swarm[0].ipv4_address
  }

  provisioner "file" {
    source      = "${path.module}/scripts/setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh",
      "docker swarm init --advertise-addr ${digitalocean_droplet.swarm[0].ipv4_address}"
    ]
  }
}

# 2.b Fetch join token by running external script locally
data "external" "worker_token" {
  program = [
    "${path.module}/scripts/get_worker_token.sh",
    digitalocean_droplet.swarm[0].ipv4_address,
    var.private_key_path
  ]

  depends_on = [null_resource.swarm_init]
}

# 2.c Workers join the swarm using token fetched from external data source
resource "null_resource" "swarm_join" {
  count = length(digitalocean_droplet.swarm) - 1

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.private_key_path)
    host        = digitalocean_droplet.swarm[count.index + 1].ipv4_address
  }

    provisioner "file" {
      source      = "${path.module}/scripts/setup.sh"
      destination = "/tmp/setup.sh"
    }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh",
      "docker swarm join --token ${data.external.worker_token.result.token} ${digitalocean_droplet.swarm[0].ipv4_address}:2377"
    ]
  }

  depends_on = [data.external.worker_token]
}