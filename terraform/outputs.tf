output "vpc_network_name" {
  description = "VPC network name"
  value       = module.vpc.network_name
}

output "gke_subnet_name" {
  description = "GKE subnetwork name"
  value       = module.vpc.subnet_name
}

output "artifact_registry_url" {
  description = "Artifact Registry Docker URL prefix"
  value       = module.artifact_registry.repository_url
}

output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = module.gke.cluster_name
}

output "gke_cluster_endpoint" {
  description = "GKE cluster master endpoint"
  value       = module.gke.cluster_endpoint
}

output "gke_node_sa" {
  description = "GKE node service account email"
  value       = module.iam.gke_node_sa_email
}

output "cicd_sa" {
  description = "GitHub Actions CI/CD service account email"
  value       = module.iam.cicd_sa_email
}
