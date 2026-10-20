output "network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "network_self_link" {
  description = "The URI of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "subnet_id" {
  description = "The ID of the subnetwork"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_name" {
  description = "The name of the subnetwork"
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_self_link" {
  description = "The URI of the subnetwork"
  value       = google_compute_subnetwork.subnet.self_link
}

output "pods_secondary_range_name" {
  description = "The secondary range name for pods"
  value       = "gke-pods"
}

output "services_secondary_range_name" {
  description = "The secondary range name for services"
  value       = "gke-services"
}
