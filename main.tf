terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0" # Use the version constraint here
    }
  }
}

# Define your provider (Google Cloud).
provider "google" {
  credentials = file("kubernetes/zinfo.json")
  project     = "zoominfo-project"
  region      = "us-central1"
}

# Create a GKE cluster.
resource "google_container_cluster" "zi_cluster" {
  name     = "zi-cluster"
  location = "us-central1"
  initial_node_count = 1

  # Specify additional configuration for your cluster (e.g., node pools).
  # ...

  depends_on = [google_project_service.k8s]
}

# Enable the Kubernetes Engine API.
resource "google_project_service" "k8s" {
  project = "zoominfo-project"
  service = "container.googleapis.com"
}

# Create a GCS Bucket IAM binding.
resource "google_storage_bucket_iam_binding" "bucket_iam" {
  bucket = "zinfo-gcs-bucket"

  role   = "roles/storage.objectViewer"
  members = ["serviceAccount:zinfo-sa@zoominfo-project.iam.gserviceaccount.com"]
}

# Create a Load Balancer.
resource "google_compute_http_health_check" "health_check" {
  name               = "health-check"
  request_path       = "/"
  port               = 80
  check_interval_sec = 5
}

resource "google_compute_instance_group" "instance_group" {
  name        = "zi-instance-group"
  zone        = "us-central1-a"  # Specify the zone for your instance group
  description = "My instance group"


  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_backend_service" "backend_service" {
  name        = "backend-service"
  description = "Backend service for your application"
  protocol    = "HTTP"
  timeout_sec = 300

  backend {
    group = google_compute_instance_group.instance_group.self_link
  }

  health_checks = [google_compute_http_health_check.health_check.id]
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "forwarding-rule"
  target     = google_compute_backend_service.backend_service.self_link
  port_range = "80"
}
