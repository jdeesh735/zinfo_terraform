resource "google_storage_bucket" "my_bucket" {
  name     = "your-gcs-bucket-name"
  location = "US"  # Change to your desired location
}

resource "google_project_iam_binding" "bucket_iam_binding" {
  project = "your-project-id"
  role    = "roles/storage.objectViewer"  # Adjust the role as needed
}

resource "google_storage_bucket_iam_binding" "bucket_iam_binding" {
  bucket = google_storage_bucket.my_bucket.name
  role   = "roles/storage.objectViewer"  # Adjust the role as needed

  members = [
    "serviceAccount:<your-service-account-email>",
  ]
}

resource "google_service_account_key" "service_account_key" {
  account_id   = "my-service-account"
  service_account_id = google_service_account.my_service_account.email
  key_algorithm = "RSA"
}

resource "google_service_account" "my_service_account" {
  account_id   = "my-service-account"
  display_name = "My Service Account"
}

# Configure your application to use this service account key for GCS access
