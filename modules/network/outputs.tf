output "network_link" {
  value = "${google_compute_network.mainnetwork.self_link}"
}


output "subnet_link" {
  value = "${google_compute_subnetwork.subnet.self_link}"
}
