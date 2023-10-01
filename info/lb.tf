resource "google_compute_global_forwarding_rule" "my_lb" {
  name       = "zi-lb"
  target     = google_container_cluster.my_cluster.endpoint
  port_range = "80"

  # Add additional LB configuration as needed
}
