variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-southeast1"
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "delivery-vpc"
}

variable "subnet_name" {
  description = "Name of the subnetwork"
  type        = string
  default     = "delivery-gke-subnet"
}

variable "subnet_cidr" {
  description = "Primary CIDR block for nodes"
  type        = string
  default     = "10.10.0.0/20"
}

variable "pods_cidr" {
  description = "Secondary CIDR block for GKE pods"
  type        = string
  default     = "10.20.0.0/16"
}

variable "services_cidr" {
  description = "Secondary CIDR block for GKE services"
  type        = string
  default     = "10.30.0.0/20"
}
