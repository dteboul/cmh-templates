#####################################################################
##
##      Created 2/28/18 by ucdpadmin. for ibm-cloud-test
##
#####################################################################

## REFERENCE {"ibm_network":{"type": "ibm_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "ibm" {
  bluemix_api_key    = "${var.ibm_bmx_api_key}"
  softlayer_username = "${var.ibm_sl_username}"
  softlayer_api_key  = "${var.ibm_sl_api_key}"
  version = "~> 0.7"
}

resource "ibm_compute_vm_instance" "vm_instance" {
  cores       = 1
  memory      = 1024
  domain      = "${var.vm_instance_domain}"
  hostname    = "${var.vm_instance_hostname}"
  datacenter  = "${var.vm_instance_datacenter}"
  ssh_key_ids = ["${ibm_compute_ssh_key.ibm_cloud_temp_public_key.id}"]
  os_reference_code = "${var.vm_instance_os_reference_code}"
  public_vlan_id       = "${var.ibm_network_public_vlan_id}"
  private_vlan_id       = "${var.ibm_network_private_vlan_id}"
  file_storage_ids = ["${ibm_storage_file.file_storage_volume.id}"]
  block_storage_ids = ["${ibm_storage_block.block_storage.id}"]
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "ibm_compute_ssh_key" "ibm_cloud_temp_public_key" {
  label = "ibm-cloud-temp-public-key"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "ibm_storage_file" "file_storage_volume" {
  type = "Performance"
  datacenter = "${var.datacenter}"
  capacity = "20"
  iops = "100"
}

resource "ibm_storage_block" "block_storage" {
  type = "Performance"
  datacenter = "${var.datacenter}"
  capacity = "20"
  iops = "100"
  os_format_type = "Linux"
}

