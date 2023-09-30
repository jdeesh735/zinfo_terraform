resource "google_compute_global_forwarding_rule" "lb" {
  name       = "my-load-balancer"
  target     = google_container_cluster.my_cluster.endpoint
  port_range = "80"
}

resource "google_compute_backend_service" "backend_service" {
  name = "my-backend-service"

  health_checks = ["health_check"]  # Replace with the actual health check name

  backend {
    group = google_container_cluster.my_cluster.node_pool[0].instance_group_urls[0]
  }

  # Add more backends if you have multiple node pools
}

resource "google_compute_url_map" "url_map" {
  name        = "my-url-map"
  default_service = google_compute_backend_service.backend_service.id

  default_route_action {
    cors_policy {
      max_age        = 3600
      allow_origins  = ["*"]
      allow_methods  = ["GET", "POST", "OPTIONS"]
      allow_headers  = ["*"]
      expose_headers = ["*"]
    }
  }
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "my-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name       = "my-http-forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"
}
