resource "google_kms_crypto_key" "cloudsource" {
  name                       = "example-key"
  key_ring                   = google_kms_key_ring.cloudsource.id
  rotation_period            = "7776000s"
  destroy_scheduled_duration = "604800s"
  lifecycle {
    prevent_destroy = true
  }
}
