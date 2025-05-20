
resource "google_compute_security_policy" "policy" {
  name        = "allow-single-ip-policy"

  rule {
    action      = "deny(403)"
    priority    = 2147483647 
    description = "Default deny rule"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }
  rule {
    action      = "allow"
    priority    = 1000  
    description = "Allow single IP address"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = [var.allowed_ip]
      }
    }
  }
}

resource "google_compute_global_address" "lb_ip" {
  name = "n8n-lb-ip"
}

resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "n8n-serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  
  cloud_run {
    service = var.cloud_run_service_name
  }
}

resource "google_compute_backend_service" "backend" {
  name                  = "n8n-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  security_policy       = google_compute_security_policy.policy.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  
  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "n8n-url-map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "n8n-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "n8n-http-rule"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
  ip_address = google_compute_global_address.lb_ip.address
}

output "load_balancer_ip" {
  value = google_compute_global_address.lb_ip.address
}
