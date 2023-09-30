# main.tf

# Configure the Google Cloud provider
provider "google" {
  credentials = file("kubernetes/zinfo.json")
}

resource "google_container_cluster" "my-cluster" {
  name     = "my-cluster"
  location = "us-central1-a"
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "my-cluster-nodes" {
  name       = "my-cluster-nodes"
  location   = google_container_cluster.my-cluster.location
  cluster    = google_container_cluster.my-cluster.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "n1-standard-1"
  }
}

resource "google_compute_address" "lb-ip" {
  name   = "lb-ip"
  region = "us-central1"
}

resource "google_compute_backend_bucket" "bucket" {
  name          = "bucket-backend"
  bucket_name   = "your-bucket-name"
  enable_cdn    = true
}

resource "google_compute_url_map" "url-map" {
  name        = "url-map"
  default_route_action {
    redirect_action {
      https_redirect_action {
        https_redirect = true
        strip_query    = true
      }
    }
  }

  default_service = google_compute_backend_bucket.bucket.id
}

resource "google_compute_target_http_proxy" "http-proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url-map.id
}

resource "google_compute_global_forwarding_rule" "forwarding-rule" {
  name       = "forwarding-rule"
  target     = google_compute_target_http_proxy.http-proxy.id
  port_range = "80"
  ip_address = google_compute_address.lb-ip.address
}

resource "google_project_iam_member" "bucket-iam-policy" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:service-${google_container_cluster.my-cluster.name}@your-project-id.iam.gserviceaccount.com"
}
