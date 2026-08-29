resource "google_pubsub_topic_iam_member" "dead_letter_publisher" {
  count = local.subscription_count

  topic  = google_pubsub_topic.dead_letter[0].id
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${coalesce(var.pubsub_service_agent_email, "unset")}"

  lifecycle {
    precondition {
      condition     = var.pubsub_service_agent_email != null
      error_message = "var.pubsub_service_agent_email must be set when var.create_subscription is true: the Pub/Sub service agent needs roles/pubsub.publisher on the dead-letter topic, or undeliverable notifications are dropped instead of dead-lettered."
    }
  }
}
