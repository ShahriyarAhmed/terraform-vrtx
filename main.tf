terraform {
required_version = ">= 1.3.0, < 2.0.0"
 backend "gcs" {
    bucket = "terraform-backend-012"
  }
}
provider "google" {
  project = "qureos-mig-gke"
  region  = "us-west1"
}

module "Storage" {
    source = "./Storage"
    project_name = "qureos-mig-gke"

}

module "VPC" {
    source = "./VPC"

}

module "n8n-sa" {
  source = "./IAM"
  account_name="n8n"
  role_list = ["roles/run.admin","secretmanager.secretAccessor"]
}

module "secret-db-credentials" {
  source = "./Secrets"
  secret_id = "stg-frontend"
}

module "CloudSQL" {
  source = "./CloudSQL"
  project_name = "qureos-mig-gke"
}

module "CloudRun" {
  source = "./CloudRun"
  vpc_connector_name = "n8n-vpc-connector"
  project_id = "qureos-mig-gke"
  image = "n8nio/n8n"
  cloud_sql_instance = "n8n-db"
}

module "LoadBalancer" {
  source = "./LB"
  project_id = "qureos-mig-gke"
  region="us-central-1"
}