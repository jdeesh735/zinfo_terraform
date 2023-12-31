resource "google_project_iam_member" "gke_bucket_access" {
  project = "zoominfo-project"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:zinfo-sa@zoominfo-project.iam.gserviceaccount.com"
}
