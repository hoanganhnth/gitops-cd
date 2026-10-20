variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "location" {
  description = "The regional location of the repository"
  type        = string
  default     = "asia-southeast1"
}

variable "repository_id" {
  description = "The ID of the Artifact Registry repository"
  type        = string
  default     = "delivery-repo"
}

variable "description" {
  description = "Description of the repository"
  type        = string
  default     = "Docker repository for Delivery platform microservices and apps"
}
