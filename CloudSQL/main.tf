variable "project_name" {}
variable "region" { default = "us-central1" }
variable "network" {default = "n8n-vpc"}


data "google_secret_manager_secret_version" "db_password" {
  secret  = "n8n-db-password"
  project = var.project_name
}



resource "google_sql_database_instance" "postgres" {
  name             = "n8n-db"
  database_version = "POSTGRES_17"
  region           = var.region
  project          = var.project_name

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.project_name}/global/networks/${var.network}"
    }
  }
}

resource "google_sql_database" "n8n" {
  name     = "n8n_db"
  instance = google_sql_database_instance.postgres.name
  project  = var.project_name
}

resource "google_sql_user" "n8n_user" {
  name     = "n8n_user"
  instance = google_sql_database_instance.postgres.name
  project  = var.project_name
  password = data.google_secret_manager_secret_version.db_password.secret_data
}
