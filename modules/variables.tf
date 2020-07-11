variable "admin_password" {
  description = "Admin Password"
  default     = "admin"
}

variable "admin_username" {
  description = "Admin Username"
  default     = "adminpassword"
}

variable "namespace" {
  description = <<EOH
this is the differantiates different demostack deployment on the same subscription, everycluster should have a different value
EOH
  default = "primarystack"
}

variable "primary_namespace" {
    description = <<EOH
this is the differantiates different demostack deployment on the same subscription, everycluster should have a different value
EOH

default = "primarystack"
}

variable "gcp_project" {
  description = "GCP project name"
}

variable "region" {
  description = "GCP region, e.g. us-east1"
}

variable "gcp_dns_zone_name" {
  description = "The name of the dns zone record in the GCP DNS console Not the FQDN"
}


variable "crypto_key" {
  default     = "vault-demostack-key"
  description = "Crypto key name to create under the key ring"
}

variable "keyring_location" {
  default = "global"
}
variable "consul_url" {
  description = "The url to download Consul."
}

variable "consul_ent_url" {
  description = "The url to download Consul."
}

variable "nomad_url" {
  description = "The url to download nomad."
}

variable "nomad_ent_url" {
  description = "The url to download nomad."
}


variable "vault_url" {
  description = "The url to download vault."
}

variable "vault_ent_url" {
  description = "The url to download vault."
}

variable "servers" {
description = "The number of data servers (consul, nomad, etc)."
default     = "3"
}

variable "workers" {
description = "The number of nomad worker vms to create."
default     = "3"
}

variable "instance_type_server" {
description = "GCP machine type"
default     = "n1-standard-4"
}
variable "instance_type_worker" {
description = "GCP machine type"
default     = "n1-standard-4"
}

variable "cust_name" {
description = "Customer name"
default     = "demo"
}

variable "image" {
description = "image to build instance from"
default     = "ubuntu-os-cloud/ubuntu-1604-lts"
}

variable "ssh_user" {
description = "Linux SSH User"
}

variable "vpc_cidr_block" {
description = "The top-level CIDR block for the VPC."
default     = "10.1.0.0/16"
}

variable "owner" {
description = "IAM user responsible for lifecycle of cloud resources used for training"
default = ""
}

variable "created-by" {
description = "Tag used to identify resources created programmatically by Terraform"
default     = "terraform"
}

variable "sleep-at-night" {
description = "Tag used by reaper to identify resources that can be shutdown at night"
default     = true
}

variable "TTL" {
description = "Hours after which resource expires, used by reaper. Do not use any unit. -1 is infinite."
default     = "240"
}

variable "demo_username" {
description = "The username to attach to the user demo login as."
default     = "demo"
}

variable "demo_password" {
description = "The password to attach to the user demo login as."
default     = "demo"
}

variable "public_key" {
description = "The contents of the SSH public key to use for connecting to the cluster."
}

variable "enterprise" {
description = "do you want to use the enterprise version of the binaries"
default     = false
}

variable "vaultlicense" {
description = "Enterprise License for Vault"
default     = ""
}

variable "consullicense" {
description = "Enterprise License for Consul"
default     = ""
}


variable "nomadlicense" {
  description = "Enterprise License for Nomad"
  default     = ""
}

variable "ca_key_algorithm" {
default = ""
}

variable "ca_private_key_pem" {
default = ""
}

variable "ca_cert_pem" {
default = ""
}

variable "consul_gossip_key" {
default = ""
}

variable "consul_master_token" {
default = ""
}

variable "consul_join_tag_key" {
default = ""
}

variable "consul_join_tag_value" {
default = ""
}

variable "nomad_gossip_key" {
default = ""
}

variable "run_nomad_jobs" {
default = 1
}

variable "zones" {
  description = "Computed zones from GCP"
}

variable "network-main" {
  description = "Computed Main Network link"
}

variable "network-sub" {
  description = "Computed Subnetwork link"
}

variable "cni_plugin_url" {
  description = "The url to download teh CNI plugin for nomad."
  default     = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
}


variable "primary_datacenter"{
  description = "the primary datacenter for mesh gateways"
  default = ""
}
