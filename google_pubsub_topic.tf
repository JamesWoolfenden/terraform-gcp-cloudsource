resource "google_pubsub_topic" "topikepic" {
  name     = var.name
  kms_key_name=var.key.id
}