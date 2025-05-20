variable "project_id" {
}

variable "region" {
}

variable "allowed_ip" {
  default     = "188.55.173.0/24" 
}

variable "cloud_run_service_name" {
  default     = "n8n-service"
}