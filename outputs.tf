// Primary

output "Primary_Servers_IP" {
  value = module.primarycluster.server_public_ip
}

output "Primary_Workers_IP" {
  value = module.primarycluster.workers_public_ip
}

output "Primary_Consul" {
  value = module.primarycluster.consul_ui
}

output "Primary_Nomad" {
  value = module.primarycluster.nomad_ui
}

output "Primary_Vault" {
  value = module.primarycluster.vault_ui
}

output "Primary_Fabio" {
  value = module.primarycluster.fabio_lb
}

output "Primary_ssh_Worked_Nodes" {
  value = [module.primarycluster.ssh_for_workers]
}

output "Primary_ssh_Server_nodes" {
  value = [module.primarycluster.ssh_for_servers]
}