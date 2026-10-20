output "repository_id" {
  description = "Artifact Registry repository ID"
  value       = google_artifact_registry_repository.repo.repository_id
}

output "repository_name" {
  description = "Artifact Registry full resource name"
  value       = google_artifact_registry_repository.repo.name
}

output "repository_url" {
  description = "Docker registry URL prefix for pushing/pulling images"
  value       = "${var.location}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}
