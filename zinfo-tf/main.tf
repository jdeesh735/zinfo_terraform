provider "google" {
  credentials = file("/home/jdeesh735/sa_tf/zoominfo/zinfo-sa_zoominfo-project.json")
  project     = "zoominfo-project"
  region      = "us-central1"
}

# Create a GCP GKE cluster.
resource "google_container_cluster" "zi_cluster" {
  name     = "zinfo-cluster"
  location = "us-central1"

  depends_on = [google_project_service.k8s]
}

# Create a GCS Bucket IAM binding.
resource "google_storage_bucket_iam_binding" "bucket_iam" {
  bucket = "zinfo-gcs-bucket"
  role   = "roles/storage.objectViewer"
  members = ["serviceAccount:zinfo-sa@zoominfo-project.iam.gserviceaccount.com"]
}

# Create a Load Balancer.
resource "google_compute_http_health_check" "zinfo_health_check" {
  name               = "zinfo_health-check"
  request_path       = "/"
  port               = 80
  check_interval_sec = 5
}

resource "google_compute_instance_group" "zinfo_instance_group" {
  name        = "zinfo_instance-group"
  description = "Instance group for your service"

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_backend_service" "zinfo_backend_service" {
  name        = "zinfo_backend-service"
  description = "Backend service for your application"
  protocol    = "HTTP"
  timeout_sec = 300

  backend {
    group = google_compute_instance_group.instance_group.self_link
  }

  health_checks = [google_compute_http_health_check.health_check.id]
}

resource "google_compute_global_forwarding_rule" "zinfo_forwarding_rule" {
  name       = "zinfo_forwarding-rule"
  target     = google_compute_backend_service.backend_service.self_link
  port_range = "80"
}
