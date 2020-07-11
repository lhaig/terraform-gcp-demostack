data "http" "myipaddr" {
    url = "http://ipv4.icanhazip.com"
}

locals {
   host_access_ip = ["${chomp(data.http.myipaddr.body)}/32"]
}


variable "gcp_project" {
  description = "GCP project name"
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


variable "secondary_namespace" {
  description = <<EOH
this is the differantiates different demostack deployment on the same subscription, everycluster should have a different value
EOH

  default = "secondarystack"
}

variable "tertiary_namespace" {
  description = <<EOH
this is the differantiates different demostack deployment on the same subscription, everycluster should have a different value
EOH

  default = "tertiarystack"
}


variable "primary_region" {
  description = "GCP region, e.g. us-east1"
  default     = "europe-west3"
}

variable "secondary_region" {
  description = "GCP region, e.g. us-east1"
  default     = "europe-west1"
}

variable "tertiary_region" {
  description = "GCP region, e.g. us-east1"
  default     = "europe-west2"
}


variable "consul_url" {
  description = "The url to download Consul."
  default = "https://releases.hashicorp.com/consul/1.5.3/consul_1.5.3_linux_amd64.zip"
}

variable "consul_ent_url" {
  description = "The url to download Consul."
  default = "https://s3-us-west-2.amazonaws.com/hc-enterprise-binaries/consul/ent/1.5.3/consul-enterprise_1.5.3%2Bent_linux_amd64.zip"
}

variable "nomad_url" {
  description = "The url to download nomad."
  default = "https://releases.hashicorp.com/nomad/0.9.4/nomad_0.9.4_linux_amd64.zip"
}

variable "nomad_ent_url" {
  description = "The url to download nomad."
  default = "https://releases.hashicorp.com/nomad/0.9.4/nomad_0.9.4_linux_amd64.zip"
}

variable "cni_plugin_url" {
  description = "The url to download teh CNI plugin for nomad."
  default     = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
}

variable "vault_url" {
  description = "The url to download vault."
  default = "https://releases.hashicorp.com/vault/1.2.1/vault_1.2.1_linux_amd64.zip"
}

variable "vault_ent_url" {
  description = "The url to download vault."
  default = "https://s3-us-west-2.amazonaws.com/hc-enterprise-binaries/vault/ent/1.2.1/vault-enterprise_1.2.1%2Bent_linux_amd64.zip"
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
default     = "n1-standard-2"
}
variable "instance_type_worker" {
description = "GCP machine type"
default     = "n1-standard-2"
}

variable "cust_name" {
description = "Customer name"
default     = "demo"
}

variable "image" {
description = "image to build instance from"
default     = "ubuntu-os-cloud/ubuntu-1604-lts"
}

variable "vpc_cidr_block" {
description = "The top-level CIDR block for the VPC."
default     = "10.1.0.0/16"
}

variable "owner" {
description = "IAM user responsible for lifecycle of cloud resources used for training"
}

variable "ssh_user" {
  description = "The ssh user for GCP compute"
  default     = ""
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


variable "primary_datacenter"{
  description = "the primary datacenter for mesh gateways"
  default = ""
}
