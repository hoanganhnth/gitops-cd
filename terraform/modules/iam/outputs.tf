output "gke_node_sa_email" {
  description = "The email address of the GKE nodes service account"
  value       = google_service_account.gke_nodes.email
}

output "cicd_sa_email" {
  description = "The email address of the CI/CD service account"
  value       = google_service_account.cicd.email
}
