resource "kubernetes_deployment" "python-app" {
  metadata {
    name = "python-app"
  }

  spec {
    replicas = 1
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
          image = "us-central1-docker.pkg.dev/zoominfo-project/ws/python-app-image:latest"
          name  = "python-app"
        }
      }
    }
  }
}

resource "kubernetes_service" "python-app" {
  metadata {
    name = "python-app"
  }

  spec {
    selector = {
      app = "python-app"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

