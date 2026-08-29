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
  description = "Fully-qualified Cloud KMS crypto key ID used to encrypt the notification Pub/Sub topic, e.g. projects/p/locations/global/keyRings/r/cryptoKeys/k"
  sensitive   = true

  validation {
    condition     = can(regex("^projects/[^/]+/locations/[^/]+/keyRings/[^/]+/cryptoKeys/[^/]+$", var.key))
    error_message = "The key must be a fully-qualified Cloud KMS crypto key ID: projects/<project>/locations/<location>/keyRings/<ring>/cryptoKeys/<key>."
  }
}

variable "message_retention_duration" {
  type        = string
  description = "How long the notification topic retains published messages for replay, as a duration in seconds (e.g. 604800s for 7 days, the Pub/Sub maximum)"
  default     = "604800s"

  validation {
    condition     = can(regex("^[0-9]+(\\.[0-9]+)?s$", var.message_retention_duration))
    error_message = "The message retention duration must be a duration in seconds, e.g. 604800s."
  }
}

variable "iam_bindings" {
  type        = map(list(string))
  description = "Map of IAM role to list of members to grant on the Cloud Source Repository, e.g. { \"roles/source.reader\" = [\"user:alice@example.com\"] }"

  validation {
    condition     = length(var.iam_bindings) > 0
    error_message = "At least one IAM binding must be specified."
  }

  validation {
    condition = !anytrue([
      for members in values(var.iam_bindings) : anytrue([
        for m in members : contains(["allUsers", "allAuthenticatedUsers"], m)
      ])
    ])
    error_message = "var.iam_bindings must not grant allUsers or allAuthenticatedUsers on the repository."
  }
}

variable "repository_readers" {
  type        = list(string)
  description = "Principals granted roles/source.reader on the repository, authoritatively for that role. Empty to create no binding"
  default     = []

  validation {
    condition     = !anytrue([for m in var.repository_readers : contains(["allUsers", "allAuthenticatedUsers"], m)])
    error_message = "var.repository_readers must not contain allUsers or allAuthenticatedUsers"
  }
}

variable "create_subscription" {
  type        = bool
  description = "Create a pull subscription (plus a dead-letter topic and its own subscription) for the repository notification topic. Off by default: without a subscription every notification the repository emits is discarded, so enable this unless a consumer attaches its own subscription to the exported topic"
  default     = false
}

variable "pubsub_service_agent_email" {
  type        = string
  description = "Email of the Pub/Sub service agent (service-PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com). Required when var.create_subscription is true, so the agent can publish to the dead-letter topic and subscribe to the notification subscription"
  default     = null

  validation {
    condition     = var.pubsub_service_agent_email == null || can(regex("^[^@]+@[^@]+$", coalesce(var.pubsub_service_agent_email, "x@y")))
    error_message = "The Pub/Sub service agent must be a bare service account email address, without the serviceAccount: prefix."
  }
}

variable "ack_deadline_seconds" {
  type        = number
  description = "Seconds Pub/Sub waits for the subscriber to acknowledge a notification before redelivering it"
  default     = 20

  validation {
    condition     = var.ack_deadline_seconds >= 10 && var.ack_deadline_seconds <= 600
    error_message = "The ack deadline must be between 10 and 600 seconds."
  }
}

variable "dead_letter_max_delivery_attempts" {
  type        = number
  description = "Delivery attempts before a notification is forwarded to the dead-letter topic"
  default     = 5

  validation {
    condition     = var.dead_letter_max_delivery_attempts >= 5 && var.dead_letter_max_delivery_attempts <= 100
    error_message = "The dead-letter max delivery attempts must be between 5 and 100."
  }
}
