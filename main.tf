terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0" # Use the version constraint here
    }
  }
}

provider "google" {
  credentials = file("kubernetes/zinfo.json")
  project     = "<your-project-id>"
  region      = "<your-region>"
}

resource "google_container_cluster" "zi-cluster" {
  name     = "zi-cluster"
  location = "us-central1"
  initial_node_count = 1

  node_pool {
    name       = "default-pool"
    machine_type = "n1-standard-1"
  }
}

resource "google_compute_instance" "zi-instance" {
  name         = "zi-instance"
  machine_type = "n1-standard-1"
  zone         = "<your-zone>"
  tags         = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
  }

  depends_on = [google_container_cluster.zi-cluster]
}

resource "google_compute_firewall" "zi-firewall" {
  name    = "zi-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_backend_service" "zi-backend-service" {
  name             = "zi-backend-service"
  backend {
    group = google_compute_instance.zi-instance.self_link
  }
  port             = 80
  protocol         = "HTTP"
  timeout_sec      = 10
  enable_cdn       = false
  health_checks   = [google_compute_http_health_check.zi-health-check.self_link]
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_http_health_check" "zi-health-check" {
  name               = "zi-health-check"
  request_path       = "/"
  port               = 80
  check_interval_sec = 5
  timeout_sec        = 5
}

resource "google_compute_url_map" "zi-url-map" {
  name     = "zi-url-map"
  
  default_route_action {
    cors_policy = google_compute_url_map_default_route_action_cors_policy.zi-cors-policy.self_link
    timeout_ms = 60000
    url_redirect_action {
      https_redirect_action {
        https_redirect_response_code = "MOVED_PERMANENTLY"
      }
    }
  }
  
  default_service = google_compute_backend_service.zi-backend-service.self_link

  route {
    description = "Route to backend service"
    match {
      path = "/"
    }
    route_action {
      weighted_action {
        default_route_action = google_compute_url_map_default_route_action.zi-default-route-action.self_link
      }
    }
  }
}


resource "google_compute_global_forwarding_rule" "zi-forwarding-rule" {
  name       = "zi-forwarding-rule"
  target     = google_compute_target_http_proxy.zi-proxy.self_link
  port_range = "80"
  global    = true
}

resource "google_compute_target_http_proxy" "zi-proxy" {
  name = "zi-proxy"
  url_map = google_compute_url_map.zi-url-map.self_link
}

resource "google_service_account" "zi-service-account" {
  account_id   = "zi-service-account"
  display_name = "My Service Account"
}

resource "google_storage_bucket_iam_binding" "zi-iam" {
  bucket = "gs://<your-bucket-name>"
  role   = "roles/storage.objectViewer"
  members = [
    "serviceAccount:${google_service_account.zi-service-account.email}",
  ]
}
