output "namespace" {
  description = "Kubernetes namespace"
  value       = kubernetes_namespace.foundry_namespace.metadata[0].name
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.foundry_of_trust.name
}

output "application_url" {
  description = "Application access URL"
  value       = var.ingress_enabled ? "http://${var.ingress_host}" : "kubectl port-forward svc/${helm_release.foundry_of_trust.name} 8080:80"
}

output "service_name" {
  description = "Kubernetes service name"
  value       = "${helm_release.foundry_of_trust.name}"
}

output "kubectl_commands" {
  description = "Useful kubectl commands"
  value = {
    port_forward = "kubectl port-forward -n ${kubernetes_namespace.foundry_namespace.metadata[0].name} svc/${helm_release.foundry_of_trust.name} 8080:80"
    logs         = "kubectl logs -n ${kubernetes_namespace.foundry_namespace.metadata[0].name} -l app.kubernetes.io/name=foundry-of-trust -f"
    describe     = "kubectl describe -n ${kubernetes_namespace.foundry_namespace.metadata[0].name} deployment ${helm_release.foundry_of_trust.name}"
    pods         = "kubectl get pods -n ${kubernetes_namespace.foundry_namespace.metadata[0].name} -l app.kubernetes.io/name=foundry-of-trust"
  }
}