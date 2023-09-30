provider "google" {
  credentials = file("zinfo.json")
  project     = "zoominfo-project"
  region      = "us-central1"
}

provider "kubernetes" {
  config_context_cluster = "gke_zoominfo-project_us-central1-a_zi-gke-cluster"  # Make sure this matches your GKE cluster name
  config_path           = "~/.kube/config"  # Adjust to your kubeconfig file location
}


variable "cluster_name" {
  default = "zi-gke-cluster"
}

variable "gcs_bucket_name" {
  default = "zinfo-gcs-bucket"
}
