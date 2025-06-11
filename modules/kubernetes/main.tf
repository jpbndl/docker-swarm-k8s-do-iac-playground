resource "digitalocean_kubernetes_cluster" "docker-associate-k8s" {
  name   = "docker-associate-k8s"
  region = var.region
  version = "1.32.2-do.3"

  node_pool {
    name       = "worker-nodes"
    size       = var.node_size
    node_count = 1
  }
}

// To make this work, follow the steps below: 
// 1. Install doctl in you local machine https://docs.digitalocean.com/reference/doctl/how-to/install/
// 2. Run this on your CLI 
//      export DIGITALOCEAN_ACCESS_TOKEN=your_token
//      To get your access token, please refer here https://docs.digitalocean.com/reference/api/create-personal-access-token/ 
resource "null_resource" "get_kubeconfig" {
  provisioner "local-exec" {
    command = <<EOT
      doctl kubernetes cluster kubeconfig save ${digitalocean_kubernetes_cluster.docker-associate-k8s.id}
    EOT
  }

  depends_on = [digitalocean_kubernetes_cluster.docker-associate-k8s]
}