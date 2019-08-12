resource "google_compute_network" "mainnetwork" {
    description             = "Main Network"
    name                    = "${var.cust_name}-vpc-network"
    auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
    description             = "Main Subnet"
    name                    = "${var.cust_name}-vpc-subnet"
    ip_cidr_range           = "${var.vpc_cidr_block}"
    network                 = "${google_compute_network.mainnetwork.self_link}"

}

resource "google_compute_firewall" "default" {
  name                    = "${var.cust_name}-fw"
  network                 = "${google_compute_network.mainnetwork.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "3000-4999", "8000-8999", "9998-9999", "20000-29999", "30000-39999"]
    # ports    = []
  }
}
