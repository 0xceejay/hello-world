# Non-hashicorp provider
terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "~> 2.0"
    }
  }
}

# Define variables
variable "do_token" {}

provider "digitalocean" {
    token = var.do_token
}

resource "digitalocean_vpc" "my_vpc" {
    name = "my-k8s-vpc"
    region = "fra1"
    ip_range = "192.168.0.0/24"
}
# Provide digital-ocean k8s cluster
resource "digitalocean_kubernetes_cluster" "my_cluster" {
    name = "example"
    region = "fra1"
    version = "1.25.4-do.0"
    vpc_uuid = digitalocean_vpc.my_vpc.id

    node_pool {
      name = "workers"
      size = "s-1vcpu-2gb"
      node_count = "2"
    }
}

output "kubeconfig" {
  value = digitalocean_kubernetes_cluster.my_cluster.kube_config[0].raw_config
  sensitive = true
}

# resource "null_resource" "save_kubeconfig" {
#   provisioner "local-exec" {
#     command = "echo ${digitalocean_kubernetes_cluster.my_cluster.kube_config} > .kube"
#   }
# }