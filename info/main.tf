provider "google" {
  credentials = file("../app/zinfo.json")
  project     = "zoominfo-project"
}

resource "google_storage_bucket" "my_bucket" {
  name     = "zinfo-bucket"
  location = "us-central1"  # Choose your preferred location

  uniform_bucket_level_access = true
}

resource "null_resource" "python_script" {
  provisioner "local-exec" {
    command = "python app.py"
  }

  # Trigger this when GKE cluster creation is complete.
  depends_on = [google_container_cluster.my_cluster]
}

