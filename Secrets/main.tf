resource "google_secret_manager_secret" "this" {
  secret_id = var.secret_id


  replication {
    user_managed {
      replicas {
        location = "europe-west1"
      }
    }
  }
}