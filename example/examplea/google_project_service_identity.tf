resource "google_project_service_identity" "pubsub" {
  provider = google-beta
  project  = var.project
  service  = "pubsub.googleapis.com"
}
