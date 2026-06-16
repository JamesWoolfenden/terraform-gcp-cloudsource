variable "project" {
  type        = string
  description = "GCP project ID to deploy resources into"

  validation {
    condition     = length(trimspace(var.project)) > 0
    error_message = "The project ID must not be empty."
  }
}
