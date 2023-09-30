# Define the Google Cloud provider configuration
provider "google" {
  credentials = file("kube/zinfo.json")  # Path to your service account JSON key file
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
    #machine_type = "n1-standard-2"  # Machine type for the nodes
    node_count = 2  # Number of nodes in the default pool
    }
  }

  # You can add more node pool blocks if needed for additional node pools
}

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
