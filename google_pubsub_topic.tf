resource "google_pubsub_topic" "pike" {
  name                       = var.name
  kms_key_name               = var.key
  message_retention_duration = "604800s" # 7 days
}
