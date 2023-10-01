resource "google_container_cluster" "my_cluster" {
  name     = "zi-cluster"
  location = "us-central1"  # Choose your preferred location

  initial_node_count = 1

  # Add additional GKE cluster configuration as needed
}
