data "template_file" "server" {
  count = var.servers

  template = "${join("\n", tolist(
    file("${path.module}/templates/shared/base.sh"),
    file("${path.module}/templates/shared/docker.sh"),
    file("${path.module}/templates/shared/run-proxy.sh"),
    file("${path.module}/templates/server/consul.sh"),
    file("${path.module}/templates/server/vault.sh"),
    file("${path.module}/templates/server/nomad.sh"),
    file("${path.module}/templates/server/nomad-jobs.sh"),
  ))}"

  vars = {
    gcp_region             = var.gcp_region
    gcp_project            = var.gcp_project
    key_ring               = google_kms_key_ring.key_ring.name
    crypto_key             = var.crypto_key
    keyring_location       = var.keyring_location
    enterprise             = var.enterprise
    vaultlicense           = var.vaultlicense
    consullicense          = var.consullicense
    namespace              = var.namespace
    node_name              = "${var.cust_name}-server-${count.index}"
    me_ca                  = var.ca_cert_pem
    me_cert                = element(tls_locally_signed_cert.server.*.cert_pem, count.index)
    me_key                 = element(tls_private_key.server.*.private_key_pem, count.index)
    # Consul
    consul_url             = var.consul_url
    consul_ent_url         = var.consul_ent_url
    consul_gossip_key      = var.consul_gossip_key
    consul_join_tag_key    = "ConsulJoin"
    consul_join_tag_value  = var.consul_join_tag_value
    consul_master_token    = var.consul_master_token
    consul_servers         = var.servers
    # Nomad
    nomad_url              = var.nomad_url
    nomad_gossip_key       = var.nomad_gossip_key
    nomad_servers          = var.servers
    # Nomad jobs
    fabio_url              = var.fabio_url
    hashiui_url            = var.hashiui_url
    run_nomad_jobs         = var.run_nomad_jobs
    # Vault
    vault_url              = var.vault_url
    vault_ent_url          = var.vault_ent_url
    vault_root_token       = random_id.vault-root-token.hex
    vault_servers          = var.servers
  }
}

resource "google_compute_target_pool" "servers" {
  name                    = "${var.cust_name}-server-pool"

  instances = [ 
    for instance in google_compute_instance.server:
    instance.self_link
  ]

  health_checks = [
    "${google_compute_http_health_check.servers.name}",
  ]
}

resource "google_compute_http_health_check" "servers" {
  name                    = "servers-healthcheck"
  request_path            = "/"
  check_interval_sec      = 1
  timeout_sec             = 1
}


# Create the Consul cluster
resource "google_compute_instance" "server" {
  count                   = var.servers
  zone                    = data.google_compute_zones.available.names[count.index]
  name                    = "${var.cust_name}-server-${count.index}"
  machine_type            = var.instance_type_server

  labels = {
    name                  = "${var.cust_name}-server-${count.index}"
    owner                 = var.owner
    created-by            = var.created-by
    sleep-at-night        = var.sleep-at-night
    ttl                   = var.TTL
    consuljoin            = var.consul_join_tag_value
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  attached_disk {
    source                = element(google_compute_disk.server-second.*.self_link, count.index)
    device_name           = "seconddisk"
  }

  network_interface {
    subnetwork            = var.network-sub
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    name                  = "${var.cust_name}-server-${count.index}"
    owner                 = var.owner
    created-by            = var.created-by
    sleep-at-night        = var.sleep-at-night
    ttl                   = var.TTL
    consuljoin            = var.consul_join_tag_value
  }

  tags                    = [
    var.consul_join_tag_value,
    "servers"
  ]

  metadata_startup_script = "${element(data.template_file.server.*.rendered, count.index)} > /home/ubuntu/gcp-userdata.sh"

  allow_stopping_for_update = true

  service_account {
    email  = google_service_account.demostack_service_account.email
    scopes = ["cloud-platform", "compute-rw", "compute-ro", "userinfo-email", "storage-ro"]
  }
}

resource "google_compute_disk" "server-second" {
  count = var.servers
  name  = "${var.cust_name}-server-data-${count.index}"
  type  = "pd-standard"
  zone  = data.google_compute_zones.available.names[count.index]
  size  = "50"
}

resource "google_dns_record_set" "servers" {
  count = var.servers
  name = "${element(google_compute_instance.server.*.name, count.index)}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.dns_zone.name

  rrdatas = ["${element(google_compute_instance.server.*.network_interface.0.access_config.0.nat_ip, count.index)}"]
}
