resource "google_project_iam_member" "gcs_access" {
  project = "zoominfo-project"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_container_cluster.zinfo-cluster.node_config[0].service_account}"
}
