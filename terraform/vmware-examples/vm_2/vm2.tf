#####################################################################
##
##      Created 2/21/18 by ucdpadmin. for vmware_vm
##
#####################################################################

## REFERENCE {"vsphere_network":{"type": "vsphere_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}


variable "user" {
  type = "string"
  description = "Generated"
}

variable "password" {
  type = "string"
  description = "Generated"
}

variable "vsphere_server" {
  type = "string"
  description = "Generated"
}

variable "allow_unverified_ssl" {
  type = "string"
  description = "Generated"
  default = "true"
}

variable "virtual_machine_name" {
  type = "string"
  description = "Virtual machine name for virtual_machine"
  default = "bradterraformtest3"
}



variable "virtual_machine_number_of_vcpu" {
  type = "string"
  description = "Number of virtual cpu's."
  default = "1"
}

variable "virtual_machine_memory" {
  type = "string"
  description = "Memory allocation."
  default = "1024"
}



variable "resource_pool_resource_pool" {
  type = "string"
  description = "Resource pool."
  default = "resgroup-27"

}

provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = "${var.allow_unverified_ssl}"
  version = "~> 1.2"
}

data "vsphere_datastore" "datastore" {
  name          = "UCD-VRA-RSX6-001"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datacenter" "dc" {
  name = "UCD_DC1"
}

data "vsphere_virtual_machine" "template" {
  name          = "CentosOS7_THIN"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          =  "VIS241"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


resource "vsphere_virtual_machine" "virtual_machine" {
  name = "${var.virtual_machine_name}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus = "${var.virtual_machine_number_of_vcpu}"
  memory = "${var.virtual_machine_memory}"
  resource_pool_id = "${var.resource_pool_resource_pool}"
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  wait_for_guest_net_timeout = -1
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 20
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
        linux_options {
           host_name = "jke-db-server"
           domain    = "rtp.raleigh.ibm.com"
        }
        network_interface {
                  ipv4_address = "9.37.204.251"
                  ipv4_netmask = 24
         }
        dns_server_list = ["9.42.106.2"]
        ipv4_gateway    = "9.37.204.1"
        dns_suffix_list = ["rtp.raleigh.ibm.com","ibm.com"]
     }
  }
}
