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


resource "kubernetes_deployment" "python_app" {
  metadata {
    name = "python-app"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "python-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "python-app"
        }
      }

      spec {
        container {
          name  = "python-app"
          image = "us-central1-docker.pkg.dev/zoominfo-project/ws/python-app-image:latest"
          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "python_app_service" {
  metadata {
    name = "python-app-service"
  }

  spec {
    selector = {
      app = "python"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
