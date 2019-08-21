resource "google_compute_forwarding_rule" "nomad" {
  project               = var.gcp_project
  name                  = "${var.cust_name}-nom-fwd"
  target                = google_compute_target_pool.nomad.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = "4646"
  ip_protocol           = "TCP"

  # labels = var.custom_labels
}

resource "google_compute_target_pool" "nomad" {
  project          = var.gcp_project
  name             = "${var.cust_name}-nom-tp"
  region           = var.gcp_region
  session_affinity = "CLIENT_IP"

  instances = [ 
    for instance in google_compute_instance.server:
    instance.self_link
  ]

  health_checks = google_compute_http_health_check.nomad.*.name
}

resource "google_compute_http_health_check" "nomad" {
  project             = var.gcp_project
  name                = "${var.cust_name}-nom-hc"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port                = "4646"
}

# Health check firewall allows ingress tcp traffic from the health check IP addresses
resource "google_compute_firewall" "nomad_health_check_fw" {
  project  = var.gcp_project
  name     = "${var.cust_name}-nom-hc-fw"
  network  = var.network-main

  allow {
    protocol = "tcp"
    ports    = ["4646"]
  }

  # These IP ranges are required for health checks
  source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]

  # Target tags define the instances to which the rule applies
  target_tags = ["servers", "workers"]
}

resource "google_dns_record_set" "nomad" {
  name = "nomad.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.dns_zone.name

  rrdatas = ["${google_compute_forwarding_rule.nomad.ip_address}"]
}