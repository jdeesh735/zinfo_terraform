# main.tf

# Configure the Google Cloud provider
provider "google" {
  credentials = file("path/to/your/service-account-key.json")
  project     = "your-project-id"
  region      = "us-central1" # Replace with your desired region
}

# Create a GKE cluster
resource "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1" # Replace with your desired zone
  initial_node_count = 1
  node_locations    = ["us-central1-a"] # Replace with your desired zone
}

# Create a GKE Kubernetes deployment and service (deploy your Java/Python application)
resource "kubernetes_deployment" "my_app" {
  metadata {
    name = "my-app"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          image = "your-docker-image" # Replace with your application's Docker image
          name  = "my-app-container"
        }
      }
    }
  }
}

# Create a Kubernetes LoadBalancer service
resource "kubernetes_service" "my_service" {
  metadata {
    name = "my-service"
  }

  spec {
    selector = {
      app = "my-app"
    }

    port {
      port        = 80
      target_port = 8080 # Replace with your application's port
    }

    type = "LoadBalancer"
  }
}
