provider "google" {
  credentials = file("zinfo.json")
  project     = "zoominfo-project"
  region      = "us-central1"
}

variable "cluster_name" {
  default = "zi-gke-cluster"
}

variable "gcs_bucket_name" {
  default = "zinfo-gcs-bucket"
}
