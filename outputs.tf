output "repository" {
  value       = google_sourcerepo_repository.pike
  description = "The source repository"
}

output "sa" {
  value       = google_service_account.pike
  description = "Details on the SA"
}

output "topic" {
  value       = google_pubsub_topic.pike
  description = "Details of the Topic"
}
