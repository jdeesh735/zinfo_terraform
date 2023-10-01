resource "google_compute_global_forwarding_rule" "lb" {
  name        = "my-lb"
  target      = google_container_cluster.my_cluster.endpoint
  port_range  = "80"
  # Customize the forwarding rule as needed.
}
