resource "google_compute_global_forwarding_rule" "http" {
  name                  = "gcp-lamp-http-lb"
  target                = google_compute_target_http_proxy.main.id
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_target_http_proxy" "main" {
  name    = "gcp-lamp-http-proxy"
  url_map = google_compute_url_map.main.id
}

resource "google_compute_url_map" "main" {
  name            = "gcp-lamp-url-map"
  default_service = google_compute_backend_service.main.id
}

resource "google_compute_backend_service" "main" {
  name                  = "gcp-lamp-backend"
  port_name             = "http"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = var.instance_group
  }

  health_checks = [google_compute_http_health_check.main.id]
}

resource "google_compute_http_health_check" "main" {
  name         = "gcp-lamp-health-check"
  request_path = "/"
  port         = 80
}
