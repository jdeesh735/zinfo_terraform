resource "google_container_cluster" "zinfo-cluster" {
  name     = var.cluster_name
  location = "us-central1-a"

  node_pool {
    name       = "default-node-pool"
    node_count = 1
    machine_type = "n1-standard-2"
  }

  master_auth {
    username = ""
    password = ""
  }
}
