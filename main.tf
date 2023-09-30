provider "google" {
  project = var.project_id
  region = var.region
}

resource "google_kubernetes_engine_cluster" "default" {
  name = "my-cluster"
  location = var.region
  node_count = 3
}

resource "google_cloud_load_balancing_backend_service" "default" {
  name = "my-backend-service"
  port_name = "http"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_cloud_load_balancing_forwarding_rule" "default" {
  name = "my-forwarding-rule"
  load_balancer_scheme = "EXTERNAL"
  port_range = "80"
  target = google_cloud_load_balancing_backend_service.default.self_link
}

resource "google_cloud_storage_bucket" "default" {
  name = "my-bucket"
}

resource "google_cloud_storage_bucket_iam_binding" "default" {
  bucket = google_cloud_storage_bucket.default.name
  role = "roles/storage.objectViewer"
  members = ["serviceAccount:${google_kubernetes_engine_cluster.default.service_account}"]
}

resource "google_cloud_storage_bucket_iam_binding" "default" {
  bucket = google_cloud_storage_bucket.default.name
  role = "roles/storage.objectViewer"
  members = ["serviceAccount:${google_app_engine_default_version.default.service_account_email}"]
}

# Python script to fetch a file from the GCS bucket and serve it to clients

import os

from google.cloud import storage

def fetch_file(filename):
  """Fetches a file from the GCS bucket."""

  client = storage.Client()
  bucket = client.get_bucket(var.bucket_name)
  blob = bucket.get_blob(filename)
  return blob.download_as_string()

def serve_file(filename):
  """Serves a file to clients."""

  response = make_response(fetch_file(filename), mimetype="text/plain")
  return response

app = Flask(__name__)

@app.route("/")
def index():
  """Returns the index page."""

  return serve_file("index.txt")

if __name__ == "__main__":
  app.run(host="0.0.0.0", port=8080)

# Deploy the Python script to App Engine

resource "google_app_engine_default_version" "default" {
  runtime = "python39"
  project = var.project_id
  app_yaml_file = "app.yaml"
  source = {
    files = [
      ".",
    ]
  }
}
