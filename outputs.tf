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
  sensitive   = true
}

output "subscription" {
  value       = one(google_pubsub_subscription.pike)
  description = "The notification subscription, or null when var.create_subscription is false"
}

output "dead_letter_topic" {
  value       = one(google_pubsub_topic.dead_letter)
  description = "The dead-letter topic, or null when var.create_subscription is false"
  sensitive   = true
}
