variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "gke_sa_name" {
  description = "Service account ID for GKE node pool"
  type        = string
  default     = "delivery-gke-nodes-sa"
}

variable "cicd_sa_name" {
  description = "Service account ID for CI/CD runners (GitHub Actions)"
  type        = string
  default     = "delivery-github-actions"
}
