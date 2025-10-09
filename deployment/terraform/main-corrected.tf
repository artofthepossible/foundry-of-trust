terraform {
  required_version = ">= 1.0"
  
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

# Configure Kubernetes provider to use local Docker Desktop cluster
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

# Configure Helm provider - correct syntax for provider block
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop"
  }
}

# Create namespace for the application
resource "kubernetes_namespace" "foundry_namespace" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"      = "foundry-of-trust"
      "app.kubernetes.io/component" = "namespace"
      "security.foundry.dev/vex"    = "true"
    }
  }
}

# Deploy the Foundry of Trust application using Helm
resource "helm_release" "foundry_of_trust" {
  name       = var.release_name
  namespace  = kubernetes_namespace.foundry_namespace.metadata[0].name
  chart      = var.helm_chart_path
  
  # Override default values
  values = [
    templatefile("${path.module}/values.yaml", {
      image_tag        = var.image_tag
      replica_count    = var.replica_count
      ingress_enabled  = var.ingress_enabled
      ingress_host     = var.ingress_host
    })
  ]

  # Wait for deployment to be ready
  wait          = true
  wait_for_jobs = true
  timeout       = 300

  # Force update on apply
  force_update = true
  
  depends_on = [kubernetes_namespace.foundry_namespace]
}