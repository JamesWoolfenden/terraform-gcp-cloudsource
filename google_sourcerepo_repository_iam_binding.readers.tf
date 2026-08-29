resource "google_sourcerepo_repository_iam_binding" "readers" {
  count = length(var.repository_readers) == 0 ? 0 : 1

  repository = google_sourcerepo_repository.pike.name
  role       = "roles/source.reader"
  members    = var.repository_readers

  lifecycle {
    precondition {
      condition     = !contains(keys(var.iam_bindings), "roles/source.reader")
      error_message = "roles/source.reader must not appear in var.iam_bindings while var.repository_readers is set: this authoritative binding and the additive google_sourcerepo_repository_iam_member grants would overwrite each other on every apply. Use one or the other for this role."
    }
  }
}
