//--------------------------EMEA-SE_PLAYGROUND------------------------------------------
# Using a single workspace:
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "emea-se-playground-2019"
    workspaces {
      name = "Lance-GCP-Demostack"
    }
  }
}

// Workspace Data
data "terraform_remote_state" "emea_se_playground_tls_root_certificate" {
  backend = "remote"
  config = {
    hostname     = "app.terraform.io"
    organization = "emea-se-playground-2019"
    workspaces = {
      name = "tls-root-certificate"
    }
  }
}

provider "google" {
  version = "~> 2.9"
  project = var.gcp_project
  region  = var.gcp_region
}

data "google_compute_zones" "available" {
}

module "network" {
  source         = "./modules/network"
  cust_name      = var.cust_name
  vpc_cidr_block = var.vpc_cidr_block
}

module "primarycluster" {
  source                = "./modules"
  ca_cert_pem           = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.ca_cert_pem
  ca_key_algorithm      = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.ca_key_algorithm
  ca_private_key_pem    = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.ca_private_key_pem
  consullicense         = var.consullicense
  consul_url            = var.consul_url
  consul_ent_url        = var.consul_ent_url
  consul_template_url   = var.consul_template_url
  consul_join_tag_value = "${var.namespace}-${data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.consul_join_tag_value}"
  consul_gossip_key     = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.consul_gossip_key
  consul_master_token   = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.consul_master_token
  created-by            = var.created-by
  demo_username         = var.demo_username
  demo_password         = var.demo_password
  enterprise            = var.enterprise
  envconsul_url         = var.envconsul_url
  fabio_url             = var.fabio_url
  hashiui_url           = var.hashiui_url
  instance_type_server  = var.instance_type_server
  instance_type_worker  = var.instance_type_worker
  namespace             = var.primary_namespace
  network-main          = module.network.network_link
  network-sub           = module.network.subnet_link
  nomad_gossip_key      = data.terraform_remote_state.emea_se_playground_tls_root_certificate.outputs.nomad_gossip_key
  nomad_url             = var.nomad_url
  nomad_ent_url         = var.nomad_ent_url
  owner                 = var.owner
  public_key            = var.public_key
  gcp_region            = var.gcp_region
  gcp_project           = var.gcp_project
  run_nomad_jobs        = var.run_nomad_jobs
  sentinel_url          = var.sentinel_url
  servers               = var.servers
  ssh_user              = var.ssh_user
  sleep-at-night        = var.sleep-at-night
  terraform_url         = var.terraform_url
  TTL                   = var.TTL
  vault_url             = var.vault_url
  vault_ent_url         = var.vault_ent_url
  vaultlicense          = var.vaultlicense
  vpc_cidr_block        = var.vpc_cidr_block
  workers               = var.workers
  zones                 = data.google_compute_zones.available
}