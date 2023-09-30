
resource "google_project_iam_member" "gcs_access" {
  project = "zoominfo-project" 
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:zinfo-svc-sa@zoominfo-project.iam.gserviceaccount.com"
}
