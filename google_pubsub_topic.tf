resource "google_pubsub_topic" "pike" {
  name                       = var.name
  kms_key_name               = var.key
  message_retention_duration = var.message_retention_duration
}

resource "google_pubsub_topic" "dead_letter" {
  count = local.subscription_count

  name                       = "${var.name}-dead-letter"
  kms_key_name               = var.key
  message_retention_duration = var.message_retention_duration
}
