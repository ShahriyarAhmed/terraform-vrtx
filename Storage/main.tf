resource "google_storage_bucket" "terraform-backend-012" {
  name          = var.bucket_name
  force_destroy = true
  location      = "EU"
  project = var.project_name
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}
