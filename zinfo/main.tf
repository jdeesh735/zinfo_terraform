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
    labels = {
      app = "python"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "python"
      }
    }

    template {
      metadata {
        labels = {
          app = "python"
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


resource "kubernetes_cluster_role" "python_role" {
  metadata {
    name = "python-role"
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "python_role_binding" {
  metadata {
    name = "python-role-binding"
  }

  role_ref {
    kind     = "ClusterRole"
    name     = kubernetes_cluster_role.python_role.name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind = "ServiceAccount"
    name = "default"
  }
}


