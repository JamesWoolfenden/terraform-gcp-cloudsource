variable "name" {
  type        = string
  description = "Name of the Cloud Source repository or resource"

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "The name must not be empty."
  }
}

variable "key" {
  type        = string
  description = "Key for Pub/Sub access"

  validation {
    condition     = length(trimspace(var.key)) > 0
    error_message = "The key must not be empty."
  }
}

variable "iam_bindings" {
  type        = map(list(string))
  description = "Map of IAM role to list of members to grant on the Cloud Source Repository, e.g. { \"roles/source.reader\" = [\"user:alice@example.com\"] }"

  validation {
    condition     = length(var.iam_bindings) > 0
    error_message = "At least one IAM binding must be specified."
  }
}
