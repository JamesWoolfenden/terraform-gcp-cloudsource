resource "google_pubsub_topic_iam_member" "pike_publisher" {
  topic  = google_pubsub_topic.pike.id
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.pike.email}"
}
