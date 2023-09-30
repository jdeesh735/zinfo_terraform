provider "google" {
  credentials = file("zinfo.json")
  project     = "zoominfo-project"
  region      = "us-central1"
}

resource "google_storage_bucket" "zinfo_bucket" {
  name          = "zinfo-bucket"
  location      = "US"
  force_destroy = true
}
