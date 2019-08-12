# Server Outputs
output "ssh_for_servers" {
  value = "${formatlist("ssh ${var.ssh_user}@%s", google_compute_instance.server.*.network_interface.0.access_config.0.nat_ip,)}"
}

output "server_instance_id" {
  value = google_compute_instance.server.*.self_link
}

output "server_public_ip" {
  value = [google_compute_instance.server.*.network_interface.0.access_config.0.nat_ip]
}

# Worker Outputs

output "ssh_for_workers" {
  value = "${formatlist("ssh ${var.ssh_user}@%s", google_compute_instance.workers.*.network_interface.0.access_config.0.nat_ip,)}"
}

output "workers_instance_id" {
  value = google_compute_instance.workers.*.self_link
}

output "workers_public_ip" {
  value = [google_compute_instance.workers.*.network_interface.0.access_config.0.nat_ip]
}

output "hashi_ui" {
  value = "${formatlist("http://%s:3000", google_compute_instance.workers.*.network_interface.0.access_config.0.nat_ip,)}"
}

output "fabio_lb" {
  value = "http://${google_compute_forwarding_rule.fabio.ip_address}:9998"
}

output "vault_ui" {
  value = "http://${google_compute_forwarding_rule.vault.ip_address}:8200"
}



# Nomad Outputs

output "nomad_ui" {
  value = "http://${google_compute_forwarding_rule.nomad.ip_address}:4646"
}

output "nomad_workers_consul_ui" {
  value = "${formatlist("http://%s:8500/", google_compute_instance.workers.*.network_interface.0.access_config.0.nat_ip,)}"
}

output "nomad_workers_ui" {
  value = "${formatlist("http://%s:3000/", google_compute_instance.workers.*.network_interface.0.access_config.0.nat_ip)}"
}

# Consul Outputs

output "consul_ui" {
  value = "http://${google_compute_forwarding_rule.consul.ip_address}:8500"
}

output "consul_forwarding_rule_link" {
  description = "CONSUL - Self link of the forwarding rule (Load Balancer)"
  value       = google_compute_forwarding_rule.consul.self_link
}

output "consul_load_balancer_ip_address" {
  description = "CONSUL - IP address of the Load Balancer"
  value       = google_compute_forwarding_rule.consul.ip_address
}

output "consul_target_pool" {
  description = "CONSUL - Self link of the target pool"
  value       = google_compute_target_pool.consul.self_link
}