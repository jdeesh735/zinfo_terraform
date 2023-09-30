# GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name     = "gke-cluster"
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

# IAM Roles and Permissions
resource "google_project_iam_member" "gke_service_account" {
  role = "roles/storage.objectViewer"
  member = "serviceAccount:zinfo-sa@zoominfo-project.iam.gserviceaccount.com"
}
