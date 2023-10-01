provider "google" {
  credentials = file("../app/zinfo.json")
  project     = "zoominfo-project"
}

resource "google_storage_bucket" "my_bucket" {
  name     = "zinfo-bucket"
  location = "us-central1"  # Choose your preferred location

  uniform_bucket_level_access = true
}
