module "cloudsource" {
  source = "../../"
  name   = "pike"
  key=google_kms_crypto_key.crypto_key
}


resource "google_kms_crypto_key" "crypto_key" {
  name     = "example-key"
  key_ring = google_kms_key_ring.key_ring.id
  rotation_period = "7776000s"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_key_ring" "key_ring" {
  name     = "example-keyring"
  location = "global"
}