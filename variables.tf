variable "project_id" {
  description = "Google Cloud Project ID"
}

variable "region" {
  description = "Google Cloud Region"
  default     = "us-central1"
}

variable "zone" {
  description = "Google Cloud Zone for GKE"
  default     = "us-central1-a"
}

variable "bucket_name" {
  description = "Name of the GCS Bucket"
  default     = "zi-sample-bucket"
}

variable "service_account_key" {
  description = "Path to the service account key JSON file"
}
