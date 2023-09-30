resource "google_project_iam_member" "gke_bucket_access" {
  project = "zoominfo-project"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_container_cluster.zi_cluster.node_service_account}"
}
