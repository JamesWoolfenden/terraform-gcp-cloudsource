resource "google_sourcerepo_repository_iam_member" "binding" {
  for_each = {
    for b in local.iam_members : "${b.role}/${b.member}" => b
  }

  repository = google_sourcerepo_repository.pike.name
  role       = each.value.role
  member     = each.value.member
}
