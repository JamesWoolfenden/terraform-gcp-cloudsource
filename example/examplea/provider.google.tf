# holden:ignore:HLD_GCP_059 — per-repo WIF SA with attribute.repository scoping
# provides equivalent least-privilege without impersonation.
provider "google" {
  project = var.project
  default_labels = {
    module     = "terraform-gcp-cloudsource"
    created_by = "terraform"
  }
}
