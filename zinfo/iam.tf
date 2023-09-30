resource "google_storage_bucket" "my_bucket" {
  name     = "zinfo-gcs-bucket"
  location = "US"  # Change to your desired location
}

resource "google_project_iam_binding" "bucket_iam_binding" {
  project = "zoominfo-project"

  role    = "roles/storage.admin"  # Replace with the desired IAM role
  members = [
    "serviceAccount:zinfo-sa@zoominfo-project.iam.gserviceaccount.com",
  ]
}


resource "google_storage_bucket_iam_binding" "bucket_iam_binding" {
  bucket = google_storage_bucket.my_bucket.name
  role   = "roles/storage.objectViewer"  # Adjust the role as needed

  members = [
    "serviceAccount:zinfo-sa@zoominfo-project.iam.gserviceaccount.com",
  ]
}

resource "google_service_account" "service_account" {
  account_id   = "my-service-account"
  display_name = "My Service Account"
  project      = "zoominfo-project"  # Replace with your actual project ID
}


resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
}


# Configure your application to use this service account key for GCS access
