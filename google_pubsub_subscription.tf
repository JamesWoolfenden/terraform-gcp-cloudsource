resource "google_pubsub_subscription" "pike" {
  count = local.subscription_count

  name  = "${var.name}-events"
  topic = google_pubsub_topic.pike.id

  message_retention_duration = var.message_retention_duration
  ack_deadline_seconds       = var.ack_deadline_seconds

  # An empty ttl means the subscription never expires. Without this Pub/Sub
  # deletes the subscription after 31 days of inactivity, silently restoring
  # the "notifications go nowhere" state this subscription exists to prevent.
  expiration_policy {
    ttl = ""
  }

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dead_letter[0].id
    max_delivery_attempts = var.dead_letter_max_delivery_attempts
  }

  # The service agent must be able to publish to the dead-letter topic before
  # this subscription starts forwarding to it, or undeliverable messages are
  # dropped instead of dead-lettered.
  depends_on = [google_pubsub_topic_iam_member.dead_letter_publisher]

  lifecycle {
    precondition {
      condition     = var.pubsub_service_agent_email != null
      error_message = "var.pubsub_service_agent_email must be set when var.create_subscription is true: the Pub/Sub service agent needs publisher access on the dead-letter topic and subscriber access on this subscription."
    }
  }
}

# holden:ignore:HLD_GCP_121: this IS the dead-letter queue — giving it its own
# dead_letter_policy would need a further DLQ for the DLQ, without end. It exists
# to satisfy HLD_GCP_281 (a dead-letter topic must have at least one subscriber)
# so undeliverable notifications are retained rather than dropped.
resource "google_pubsub_subscription" "dead_letter" {
  count = local.subscription_count

  name  = "${var.name}-dead-letter"
  topic = google_pubsub_topic.dead_letter[0].id

  message_retention_duration = var.message_retention_duration

  expiration_policy {
    ttl = ""
  }
}
