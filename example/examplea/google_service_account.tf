resource "google_service_account" "reader" {
  account_id   = "csr-reader"
  display_name = "Cloud Source Repository reader"
}

resource "google_service_account" "writer" {
  account_id   = "csr-writer"
  display_name = "Cloud Source Repository writer"
}
