resource "google_container_cluster" "zi_cluster" {
  name     = "zi-cluster"
  location = "us-central1"

  # Node Pool Configuration
  node_pool {
    name               = "default-pool"
    initial_node_count = 1
    machine_type       = "e2-medium"
    disk_size_gb       = 50
    node_count         = 1

    # Node Auto-Repair and Auto-Upgrade
    management {
      auto_repair  = true
      auto_upgrade = true
    }

    # Node Labels (optional)
    node_labels = {
      "env" = "dev"
    }
  }

  # Kubernetes Version
  min_master_version = "1.25"
}

output "cluster_endpoint" {
  value = google_container_cluster.zi_cluster.endpoint
}

output "cluster_master_auth" {
  value = google_container_cluster.zi_cluster.master_auth
}
