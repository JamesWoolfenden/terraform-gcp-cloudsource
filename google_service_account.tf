resource "google_service_account" "pike" {
  account_id   = "${var.name}-account"
  display_name = "${var.name} Service Account"
}
