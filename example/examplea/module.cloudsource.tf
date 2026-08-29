# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "cloudsource" {
  source = "../../"
  name   = "pike"
  key    = google_kms_crypto_key.cloudsource.id

  # The Pub/Sub service agent must hold cryptoKeyEncrypterDecrypter on the CMEK
  # before the module's topic is created, or the API rejects topic creation.
  depends_on = [google_kms_crypto_key_iam_member.pubsub_cmek]

  # Without a subscription the repository's commit notifications are published
  # and then discarded. The service agent is the same one that already holds
  # cryptoKeyEncrypterDecrypter on the CMEK above.
  create_subscription        = true
  pubsub_service_agent_email = google_project_service_identity.pubsub.email

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
