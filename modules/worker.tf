data "template_file" "workers" {
  count = var.workers

  template = join(
    "\n",
    [
      file("${path.module}/templates/shared/base.sh"),
      file("${path.module}/templates/shared/docker.sh"),
      file("${path.module}/templates/shared/run-proxy.sh"),
      file("${path.module}/templates/workers/user.sh"),
      file("${path.module}/templates/workers/consul.sh"),
      file("${path.module}/templates/workers/vault.sh"),
      file("${path.module}/templates/workers/nomad.sh"),
      file("${path.module}/templates/workers/nomadjobs.sh"),
    ],
  )

  vars = {
    namespace             = var.namespace
    node_name             = "${var.cust_name}-workers-${count.index}"
    identity              = "${var.cust_name}-workers-${count.index}"
    enterprise            = var.enterprise
    gcp_region            = var.gcp_region
    gcp_project           = var.gcp_project
    me_ca                 = var.ca_cert_pem
    me_cert               = element(tls_locally_signed_cert.workers.*.cert_pem, count.index)
    me_key                = element(tls_private_key.workers.*.private_key_pem, count.index)
    # User
    demo_username         = var.demo_username
    demo_password         = var.demo_password
    # Consul
    consul_url            = var.consul_url
    consul_ent_url        = var.consul_ent_url
    consul_gossip_key     = var.consul_gossip_key
    consul_join_tag_key   = "ConsulJoin"
    consul_join_tag_value = var.consul_join_tag_value
    # Terraform
    terraform_url         = var.terraform_url
    # Tools
    consul_template_url   = var.consul_template_url
    envconsul_url         = var.envconsul_url
    sentinel_url          = var.sentinel_url
    # Nomad
    nomad_url             = var.nomad_url
    run_nomad_jobs        = var.run_nomad_jobs
    # Vault
    vault_url             = var.vault_url
    vault_ent_url         = var.vault_ent_url
    vault_root_token      = random_id.vault-root-token.hex
    vault_servers         = var.workers
  }
}

resource "google_compute_target_pool" "workers" {
  name = "${var.cust_name}-worker-pool"

  instances = [ 
    for instance in google_compute_instance.workers:
    instance.self_link
  ]

  health_checks = [
    "${google_compute_http_health_check.workers.name}",
  ]
}

resource "google_compute_http_health_check" "workers" {
  name                    = "workers-healthcheck"
  request_path            = "/"
  check_interval_sec      = 1
  timeout_sec             = 1
}

resource "google_compute_instance" "workers" {
  count                   = var.workers
  zone                    = data.google_compute_zones.available.names[count.index]
  name                    = "${var.cust_name}-workers-${count.index}"
  machine_type            = var.instance_type_worker

  labels = {
    name                  = "${var.cust_name}-workers-${count.index}"
    owner                 = var.owner
    created-by            = var.created-by
    sleep-at-night        = var.sleep-at-night
    ttl                   = var.TTL
    consuljoin            = var.consul_join_tag_value
  }

  boot_disk {
    initialize_params {
      image               = var.image
    }
  }

  attached_disk {
    source                = element(google_compute_disk.workers-second.*.self_link, count.index)
    device_name           = "seconddisk"
  }

  network_interface {
    subnetwork            = var.network-sub
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    name                  = "${var.cust_name}-workers-${count.index}"
    owner                 = var.owner
    created-by            = var.created-by
    sleep-at-night        = var.sleep-at-night
    ttl                   = var.TTL
    consuljoin            = var.consul_join_tag_value
  }
  tags                    = [
    var.consul_join_tag_value,
    "workers"
  ]

  metadata_startup_script = "${element(data.template_file.workers.*.rendered, count.index)} > /home/ubuntu/gcp-userdata.sh"
  allow_stopping_for_update = true

  service_account {
    email                 = google_service_account.demostack_service_account.email
    scopes                = ["cloud-platform", "compute-rw", "compute-ro", "userinfo-email", "storage-ro"]
  }
}

resource "google_compute_disk" "workers-second" {
  count = var.workers
  name = "${var.cust_name}-workers-data-${count.index}"
  type = "pd-standard"
  zone = data.google_compute_zones.available.names[count.index]
  size = "50"
}
