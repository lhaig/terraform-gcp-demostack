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


output "fabio_lb" {
  value = "http://${substr(google_dns_record_set.fabio.name, 0, length(google_dns_record_set.fabio.name) -1)}:9998"
}

output "vault_ui" {
  value = "https://${substr(google_dns_record_set.vault.name, 0, length(google_dns_record_set.vault.name) -1)}:8200"
}



# Nomad Outputs

output "nomad_ui" {
  value = "http://${substr(google_dns_record_set.nomad.name, 0, length(google_dns_record_set.nomad.name) -1)}:4646"
}

output "nomad_workers_consul_ui" {
  value = [ 
    for record in google_dns_record_set.workers:
      "http://${substr(record.name, 0, length(record.name) -1)}:8500"
  ]
}

output "nomad_workers_ui" {
  value = [ 
    for record in google_dns_record_set.workers:
      "http://${substr(record.name, 0, length(record.name) -1)}:3000"
  ]
}

# Consul Outputs

output "consul_ui" {
  value = "http://${substr(google_dns_record_set.consul.name, 0, length(google_dns_record_set.consul.name) -1)}:8500"
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