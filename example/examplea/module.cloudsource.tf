# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "cloudsource" {
  source = "../../"
  name   = "pike"
  key    = google_kms_crypto_key.cloudsource.id
  iam_bindings = {
    "roles/source.reader" = ["serviceAccount:${google_service_account.reader.email}"]
    "roles/source.writer" = ["serviceAccount:${google_service_account.writer.email}"]
  }
}


resource "google_kms_crypto_key" "cloudsource" {
  name            = "example-key"
  key_ring        = google_kms_key_ring.cloudsource.id
  rotation_period = "7776000s"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_key_ring" "cloudsource" {
  name     = "example-keyring"
  location = "global"
}
