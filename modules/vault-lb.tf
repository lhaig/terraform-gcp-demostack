resource "google_compute_forwarding_rule" "vault" {
  project               = var.gcp_project
  name                  = "${var.cust_name}-vau-fwd"
  target                = google_compute_target_pool.vault.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = "8200"
  ip_protocol           = "TCP"

  # labels = var.custom_labels
}

resource "google_compute_target_pool" "vault" {
  project          = var.gcp_project
  name             = "${var.cust_name}-vau-tp"
  region           = var.gcp_region
  session_affinity = "CLIENT_IP"

  instances = [ 
    for instance in google_compute_instance.server:
    instance.self_link
  ]

  health_checks = google_compute_http_health_check.vault.*.name
}

resource "google_compute_http_health_check" "vault" {
  project             = var.gcp_project
  name                = "${var.cust_name}-vau-hc"
  request_path        = "/v1/sys/health"
  port                = "8200"
  check_interval_sec  = "5"
  healthy_threshold   = "2"
  unhealthy_threshold = "2"
  timeout_sec         = "2"
}

# Health check firewall allows ingress tcp traffic from the health check IP addresses
resource "google_compute_firewall" "vault_health_check_fw" {
  project  = var.gcp_project
  name     = "${var.cust_name}-vau-hc-fw"
  network  = var.network-main

  allow {
    protocol = "tcp"
    ports    = ["8200"]
  }

  # These IP ranges are required for health checks
  source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]

  # Target tags define the instances to which the rule applies
  target_tags = ["servers", "workers"]
}

resource "google_dns_record_set" "vault" {
  name = "vault.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.dns_zone.name

  rrdatas = ["${google_compute_forwarding_rule.vault.ip_address}"]
}