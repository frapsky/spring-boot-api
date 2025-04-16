resource "google_compute_global_address" "lb_ip" {
  name    = "webserver-${var.environment}-lb-ip"
  project = var.project_id
}

resource "google_compute_backend_service" "web_backend" {
  name        = "webserver-${var.environment}-backend"
  project     = var.project_id
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group           = module.mig.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  health_checks = [google_compute_health_check.http_health_check.id]
}

resource "google_compute_url_map" "default_map" {
  name            = "webserver-${var.environment}-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.web_backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "webserver-${var.environment}-http-proxy"
  project = var.project_id
  url_map = google_compute_url_map.default_map.id
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name                  = "webserver-${var.environment}-http-fw-rule"
  project               = var.project_id
  target                = google_compute_target_http_proxy.http_proxy.id
  ip_address            = google_compute_global_address.lb_ip.address
  port_range            = "80"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED" # Use EXTERNAL for classic LB
}
