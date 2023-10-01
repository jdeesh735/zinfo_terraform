resource "google_storage_bucket_iam_binding" "bucket_iam_binding" {
  bucket = "zinfo-gcs-bucket"  # Replace with your GCS bucket name.
  role   = "roles/storage.objectViewer"
  members = [
    "serviceAccount:${google_container_cluster.my_cluster.node_config.0.service_account}",
  ]
}
