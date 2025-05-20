variable "project_id" {
}

variable "region" {
  default     = "us-central1"
}

variable "service_name" {
  default     = "n8n-service"
}

variable "image" {
}

variable "vpc_connector_name" {
}

variable "cloud_sql_instance" {
}

variable "volume_name" {
  default     = "n8n-data"
}

variable "mount_path" {
  default     = "home/node/.n8n"
}