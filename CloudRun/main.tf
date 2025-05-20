resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = "n8n-sa@${var.project_id}.iam.gserviceaccount.com"
      
      containers {
        image = var.image
        volume_mounts {
          name       = var.volume_name
          mount_path = var.mount_path
        }

      }

      volumes {
        name = var.volume_name
      }
    }

    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = var.vpc_connector_name
        "run.googleapis.com/cloudsql-instances" = var.cloud_sql_instance
        "run.googleapis.com/ingress" = "internal"
      }
    }
  }
}


resource "google_vpc_access_connector" "connector" {
  name          = var.vpc_connector_name
  region        = var.region
  ip_cidr_range = "10.8.0.0/28"
  network       = "n8n-vpc"
}


output "service_url" {
  value = google_cloud_run_service.service.status[0].url
}