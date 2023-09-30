resource "google_container_cluster" "zi_cluster" {
  name     = "zi-cluster"
  location = "us-central1"

  # Node Pool Configuration
  node_pool {
    name               = "default-pool"
#    initial_node_count = 1
    node_count         = 1

    # Node Auto-Repair and Auto-Upgrade
    management {
      auto_repair  = true
      auto_upgrade = true
    }
  }
  # Kubernetes Version
  min_master_version = "1.25"
}
