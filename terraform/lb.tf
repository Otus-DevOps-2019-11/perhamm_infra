resource "google_compute_global_address" "external-address" {
  name = "lb-external-address"
}

resource "google_compute_instance_group" "app-resources" {

  name = "lb-app-resources"

  instances = [for i in google_compute_instance.app.*.self_link : i]

  zone = var.region
  named_port {
    name = "http"
    port = "9292"
  }
}



resource "google_compute_health_check" "health-check" {
  name        = "lb-health-check"
  description = "Health check via http"

  timeout_sec         = 5
  check_interval_sec  = 30
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port = 9292
  }
}



resource "google_compute_backend_service" "app-service" {
  name     = "lb-app-service"
  protocol = "HTTP"

  backend {
    group = google_compute_instance_group.app-resources.self_link
  }

  health_checks = [google_compute_health_check.health-check.self_link]
}


resource "google_compute_url_map" "web-map" {
  name            = "lb-web-map"
  default_service = google_compute_backend_service.app-service.self_link
}



resource "google_compute_target_http_proxy" "http-lb-proxy" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.web-map.self_link
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "lb-http-content"
  target     = google_compute_target_http_proxy.http-lb-proxy.self_link
  ip_address = google_compute_global_address.external-address.address
  port_range = "80"
}
