resource "google_pubsub_topic" "pike" {
  name         = var.name
  kms_key_name = var.key.id
}
