variable "namespace" {
  description = "Kubernetes namespace for the Foundry of Trust application"
  type        = string
  default     = "foundry-of-trust"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "foundry-of-trust"
}

variable "helm_chart_path" {
  description = "Path to the Helm chart"
  type        = string
  default     = "../helm/foundry-of-trust"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "v1.1-DHI-fixed"
}

variable "replica_count" {
  description = "Number of application replicas"
  type        = number
  default     = 2
}

variable "ingress_enabled" {
  description = "Enable ingress for the application"
  type        = bool
  default     = false
}

variable "ingress_host" {
  description = "Ingress host name"
  type        = string
  default     = "foundry-of-trust.local"
}