#####################################################################
##
##      Created 10/12/20 by ucdpadmin for cloud ibmcloud. for test-cam-project2
##
#####################################################################

## REFERENCE {"ibm_network":{"type": "ibm_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "ibm" {
  version = "~> 0.7"
}

resource "ibm_compute_vm_instance" "webserver" {
  cores       = 1
  memory      = 1024
  domain      = "${var.vm_instance_domain}"
  hostname    = "${var.vm_instance_hostname}"
  datacenter  = "${var.vm_instance_datacenter}"
  ssh_key_ids = ["${ibm_compute_ssh_key.auth.id}"]
  os_reference_code = "${var.vm_instance_os_reference_code}"
  hourly_billing = true
  public_vlan_id       = "${var.ibm_network_public_vlan_id}"
  private_vlan_id       = "${var.ibm_network_private_vlan_id}"
}

resource "ibm_compute_vm_instance" "dbserver" {
  cores       = 1
  memory      = 1024
  domain      = "${var.vm_instance_domain}"
  hostname    = "${var.vm_instance1_hostname}"
  datacenter  = "${var.vm_instance_datacenter}"
  ssh_key_ids = ["${ibm_compute_ssh_key.auth.id}"]
  os_reference_code = "${var.vm_instance1_os_reference_code}"
  public_vlan_id       = "${var.ibm_network_public_vlan_id}"
  private_vlan_id       = "${var.ibm_network_private_vlan_id}"
  file_storage_ids = ["${ibm_storage_file.file_storage.id}"]
  hourly_billing = true
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "ibm_compute_ssh_key" "auth" {
  label = "CAM Public Key"
  public_key = "${var.ibm_ssh_key_name}"
}

resource "ibm_storage_file" "file_storage" {
  type = "Performance"
  datacenter = "${var.vm_instance_datacenter}"
  capacity = "20"
  iops = "100"
  hourly_billing = true
}