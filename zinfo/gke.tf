provider "google" {
  credentials = file("<path_to_your_service_account_json>")
  project     = "your-project-id"
  region      = "us-central1"  # Change to your desired region
}

resource "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1"  # Change to your desired region

  node_pool {
    name       = "default-pool"
    node_count = 2  # Change to your desired node count
  }

  # Add more node_pool blocks if needed
}

resource "google_container_node_pool" "additional_node_pool" {
  name       = "additional-pool"
  location   = google_container_cluster.my_cluster.location
  cluster    = google_container_cluster.my_cluster.name
  node_count = 3  # Change to your desired node count for additional pool

  # Customize other node pool settings as needed
}

# Define your Kubernetes deployment and service here
