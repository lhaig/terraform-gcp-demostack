data "google_compute_zones" "available" {
}

resource "google_service_account" "demostack_service_account" {
  account_id   = "demo-${var.namespace}-gcpkms"
  display_name = "Vault KMS for auto-unseal"
}

resource "google_project_iam_custom_role" "demostack" {
  role_id     = "DemostackRole"
  title       = "demostack_role"
  description = "Demostack Custom Role"
  permissions = [
    "compute.instances.list", 
    "compute.zones.list",
    "cloudkms.cryptoKeyVersions.useToEncrypt",
    "cloudkms.cryptoKeyVersions.useToDecrypt",
    "cloudkms.cryptoKeys.get",
    "compute.disks.create", 
    "compute.firewalls.create", 
    "compute.firewalls.delete", 
    "compute.firewalls.get", 
    "compute.instanceGroupManagers.get", 
    "compute.instances.create", 
    "compute.instances.delete", 
    "compute.instances.get", 
    "compute.instances.setMetadata", 
    "compute.instances.setServiceAccount", 
    "compute.instances.setTags", 
    "compute.machineTypes.get", 
    "compute.networks.create", 
    "compute.networks.delete", 
    "compute.networks.get", 
    "compute.networks.updatePolicy", 
    "compute.subnetworks.create", 
    "compute.subnetworks.delete", 
    "compute.subnetworks.get", 
    "compute.subnetworks.setPrivateIpGoogleAccess", 
    "compute.subnetworks.update", 
    "compute.subnetworks.use", 
    "compute.subnetworks.useExternalIp", 
    "compute.zones.get"
    ]
}

resource "google_project_iam_binding" "demostack" {
  role = "projects/${var.gcp_project}/roles/${google_project_iam_custom_role.demostack.role_id}"

  members = [
    "serviceAccount:${google_service_account.demostack_service_account.email}",
  ]
}

resource "random_id" "gcp_kms_key" {
  byte_length = 8
  prefix      = "${var.namespace}-"
}

# Create a KMS key ring
resource "google_kms_key_ring" "key_ring" {
  project  = var.gcp_project
  name     = "DemoStack-key-${random_id.gcp_kms_key.hex}"
  location = var.keyring_location
}

# Create a crypto key for the key ring
resource "google_kms_crypto_key" "crypto_key" {
  name            = var.crypto_key
  key_ring        = google_kms_key_ring.key_ring.self_link
  rotation_period = "100000s"
}


# Add the service account to the Keyring
resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  key_ring_id = google_kms_key_ring.key_ring.id
  role = "roles/owner"

  members = [
    "serviceAccount:${google_service_account.demostack_service_account.email}",
  ]
}