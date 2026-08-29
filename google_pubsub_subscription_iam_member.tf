# Granted on the subscription, so it necessarily applies after the
# subscription exists; the ordering guarantee that matters is the publisher
# grant on the dead-letter topic, which google_pubsub_subscription.pike
# depends_on directly.
resource "google_pubsub_subscription_iam_member" "pike_subscriber" {
  count = local.subscription_count

  subscription = google_pubsub_subscription.pike[0].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${coalesce(var.pubsub_service_agent_email, "unset")}"

  lifecycle {
    precondition {
      condition     = var.pubsub_service_agent_email != null
      error_message = "var.pubsub_service_agent_email must be set when var.create_subscription is true: the Pub/Sub service agent needs roles/pubsub.subscriber on the notification subscription to forward undeliverable messages to the dead-letter topic."
    }
  }
}
