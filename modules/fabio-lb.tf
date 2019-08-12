resource "google_compute_forwarding_rule" "fabio" {
  project               = var.gcp_project
  name                  = "${var.cust_name}-fab-fwd"
  target                = google_compute_target_pool.fabio.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = "9998-9999"
  ip_protocol           = "TCP"

  # labels = var.custom_labels
}

resource "google_compute_target_pool" "fabio" {
  project          = var.gcp_project
  name             = "${var.cust_name}-fab-tp"
  region           = var.gcp_region
  session_affinity = "CLIENT_IP"

  instances = [ 
    for instance in google_compute_instance.server:
    instance.self_link
  ]

  health_checks = google_compute_http_health_check.fabio.*.name
}

resource "google_compute_http_health_check" "fabio" {
  project             = var.gcp_project
  name                = "${var.cust_name}-fab-hc"
  request_path        = "/health"
  port                = "9998"
  check_interval_sec  = "5"
  healthy_threshold   = "2"
  unhealthy_threshold = "2"
  timeout_sec         = "2"
}

# Health check firewall allows ingress tcp traffic from the health check IP addresses
resource "google_compute_firewall" "fabio_health_check_fw" {
  project  = var.gcp_project
  name     = "${var.cust_name}-fab-hc-fw"
  network  = var.network-main

  allow {
    protocol = "tcp"
    ports    = ["9998-9999"]
  }

  # These IP ranges are required for health checks
  source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]

  # Target tags define the instances to which the rule applies
  target_tags = ["servers", "workers"]
}