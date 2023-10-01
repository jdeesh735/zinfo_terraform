provider "google" {
  credentials = file("zinfo.json")
  project     = "zoominfo-project"
  region      = "us-central1"
}
resource "google_storage_bucket" "my_bucket" {
  name     = "zinfo-bucket"
  location = "us-central1"
  uniform_bucket_level_access = true
}
# GKE Cluster
resource "google_container_cluster" "zi_cluster" {
  name     = "zi-cluster"
  location = "us-central1-a"
  initial_node_count = 1
  node_config {
    machine_type = "e2-standard-2"
  }
}
# Load Balancer
resource "google_compute_target_pool" "lb_target_pool" {
  name = "zi-lb-target-pool"
}
resource "google_compute_http_health_check" "lb_health_check" {
  name               = "zi-lb-health-check"
  port               = 80
  request_path       = "/"
  check_interval_sec = 10
  timeout_sec        = 5
}
resource "google_compute_forwarding_rule" "lb_forwarding_rule" {
  name       = "zi-lb-forwarding-rule"
  target     = google_compute_target_pool.lb_target_pool.id
  port_range = "80"
}
resource "google_storage_bucket_iam_binding" "bucket_iam_binding" {
  bucket = "zinfo-bucket"  # Replace with your GCS bucket name without the "b/" prefix.
  role   = "roles/storage.objectViewer"
  members = [
    "serviceAccount:gke-service-account@zoominfo-project.iam.gserviceaccount.com",
  ]
}
