terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0" # Use the version constraint here
    }
  }
}
provider "google" {
  #credentials = file("kubernetes/zinfo.json")
  project = var.project_id
  region = var.region
}

resource "google_kubernetes_engine_cluster" "default" {
  name = "zi-gke-cluster"
  location = var.region
  node_count = 3
}

resource "google_compute_load_balancer" "default" {
  name = "zi-load-balancer"
  type = "loadBalancingScheme::EXTERNAL"
  port_range = "80-80"
  health_checks = ["TCP:80"]

  backend_configuration {
    name = "zi-backend-config"
    backends {
      group = google_kubernetes_engine_backend_service.default.name
    }
  }
}

resource "google_kubernetes_engine_backend_service" "default" {
  name = "zi-backend-service"
  port_name = "http"
  target_port = 80
  selector = {
    app = "zi-app"
  }
}

resource "google_storage_bucket_iam_binding" "default" {
  bucket = var.gcs_bucket_name
  role = "roles/storage.objectViewer"
  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}

resource "google_service_account" "default" {
  name = "zi-service-account"
}
