terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
  }
}

provider "kubernetes" {
	config_path = "/home/caption/.kube/config"
}

provider "docker" {
  host = "tcp://localhost:2376"
}

resource "kubernetes_deployment" "flask" {
  metadata {
    name	= "flaskapp-deployment"
	
  
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        App = "flaskapp"
      }
    }
    template {
      metadata {
        labels = {
          App = "flaskapp"
        }
      }
      spec {
        container {
          image = "sushilgautam/flask-final-app:latest"
          name  = "myflaskapp"

          port {
            container_port = 8222
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "flask" {
  metadata {
    name	= "flask-service"												 
  }
  spec {
    selector = {
      App = kubernetes_deployment.flask.spec.0.template.0.metadata.0.labels.App
    }
    port {
      node_port   = 30201
      port        = 8222
      target_port = 8222
    }

    type = "NodePort"
  }
}
