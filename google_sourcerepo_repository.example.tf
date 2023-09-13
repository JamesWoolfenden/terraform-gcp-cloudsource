resource "google_sourcerepo_repository" "example" {
  name = var.name
  pubsub_configs {
      topic = google_pubsub_topic.pike.id
      message_format = "JSON"
      service_account_email = google_service_account.pike.email
  }
}
