variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP Region for GKE cluster"
  type        = string
  default     = "asia-southeast1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "delivery-cluster"
}

variable "network" {
  description = "The VPC network self link or name"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork self link or name"
  type        = string
}

variable "pods_secondary_range_name" {
  description = "The secondary range name for pods"
  type        = string
  default     = "gke-pods"
}

variable "services_secondary_range_name" {
  description = "The secondary range name for services"
  type        = string
  default     = "gke-services"
}

variable "node_service_account" {
  description = "Service account email for GKE nodes"
  type        = string
}

variable "initial_node_count" {
  description = "Initial node count per zone"
  type        = number
  default     = 0
}

variable "node_count_min" {
  description = "Minimum node count per zone for autoscaler"
  type        = number
  default     = 0
}

variable "node_count_max" {
  description = "Maximum node count per zone for autoscaler"
  type        = number
  default     = 3
}

variable "machine_type" {
  description = "Machine type for worker nodes"
  type        = string
  default     = "e2-standard-4"
}

variable "disk_size_gb" {
  description = "Disk size per node in GB"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Disk type for nodes"
  type        = string
  default     = "pd-standard"
}

variable "spot_instances" {
  description = "Use Spot (preemptible) VMs for node pool"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "CIDR range for GKE master control plane"
  type        = string
  default     = "172.16.0.0/28"
}
