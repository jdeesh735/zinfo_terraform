provider "google" {
  credentials = file("zinfo.json")
  project     = "zoominfo-project"
  region      = "us-central1"  # Replace with your desired region
}


# GKE Cluster
resource "google_container_cluster" "zi_cluster" {
  name     = "zi-cluster"
  location = "us-central1-a"
  initial_node_count = 1
  node_config {
    machine_type = "n1-standard-2"
  }
}

# Load Balancer
resource "google_compute_target_pool" "lb_target_pool" {
  name = "lb-target-pool"
}

resource "google_compute_http_health_check" "lb_health_check" {
  name               = "lb-health-check"
  port               = 80
  request_path       = "/"
  check_interval_sec = 10
  timeout_sec        = 5
}

resource "google_compute_forwarding_rule" "lb_forwarding_rule" {
  name       = "lb-forwarding-rule"
  target     = google_compute_target_pool.lb_target_pool.id
  port_range = "80"
}

resource "google_project_iam_member" "gke_service_account" {
  project = "zoominfo-project"  # Replace with your actual project ID
  role    = "roles/storage.admin"  # Replace with the desired IAM role
  member  = "serviceAccount:zinfo-sa@zoominfo-project.iam.gserviceaccount.com"  # Replace with the service account email
}

