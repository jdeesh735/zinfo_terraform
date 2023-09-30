# Define the Google Cloud provider configuration
provider "google" {
  credentials = file("kubernetes/zinfo.json")  # Path to your service account JSON key file
  project     = "zoominfo-project"  # Your Google Cloud project ID
  region      = "us-central1"  # Your desired region
}

# Define the Google Kubernetes Engine (GKE) cluster resource
resource "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"  # Your desired GKE cluster name
  location = "us-central1"  # Your desired region

  # Define the default node pool for your GKE cluster
  node_pool {
    name       = "default-pool"
    machine_type = "n1-standard-2"  # Machine type for the nodes
    node_count = 2  # Number of nodes in the default pool
    min_count  = 1  # Minimum number of nodes (optional)
    max_count  = 2  # Maximum number of nodes (optional)

    # Define node pool auto-upgrade and auto-repair settings (optional)
    management {
      auto_upgrade = true
      auto_repair  = true
    }
  }

  # You can add more node pool blocks if needed for additional node pools
}

# Define additional Google Container Node Pool resource (if needed)
resource "google_container_node_pool" "additional_node_pool" {
  name       = "additional-pool"  # Your desired node pool name
  location   = google_container_cluster.my_cluster.location  # Use the location of the GKE cluster
  cluster    = google_container_cluster.my_cluster.name  # Reference the GKE cluster by name
  node_count = 3  # Number of nodes in this node pool

  # Customize other node pool settings as needed
}

# Define your Kubernetes deployment and service configurations here
# For example, you can use the "kubernetes" provider to define Kubernetes resources
# such as Deployments, Services, ConfigMaps, etc.
# Refer to Terraform Kubernetes provider documentation for details: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

# Example Kubernetes Deployment
resource "kubernetes_deployment" "example_deployment" {
  metadata {
    name = "example-app"
  }

  spec {
    replicas = 2

    template {
      metadata {
        labels = {
          app = "example"
        }
      }

      spec {
        container {
          name  = "example-container"
          image = "nginx:latest"
        }
      }
    }
  }
}

# Example Kubernetes Service
resource "kubernetes_service" "example_service" {
  metadata {
    name = "example-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.example_deployment.spec.0.template.0.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}
