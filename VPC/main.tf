resource "google_compute_network" "this" {
  name = "${var.name}-vpc"
  delete_default_routes_on_create = false
  auto_create_subnetworks = false
  routing_mode  = "REGIONAL"
}

resource "google_compute_subnetwork" "this" {
name="${var.private_subnet}-subnetwork"
ip_cidr_range= var.private_subnet_ip_cidr_range
region=var.region
network=google_compute_network.this.id
private_ip_google_access =true
depends_on = [google_compute_network.this]
}
output "vpc_name" {
  value = google_compute_network.this.name
}
output "subnet_name" {
  value = google_compute_subnetwork.this.name
}
