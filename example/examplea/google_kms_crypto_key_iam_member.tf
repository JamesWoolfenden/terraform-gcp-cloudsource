resource "google_kms_crypto_key_iam_member" "pubsub_cmek" {
  crypto_key_id = google_kms_crypto_key.cloudsource.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.pubsub.email}"
}
