#####################################################################
##
##      Created 5/6/19 by admin. For Cloud vra3 for vcenter-single-vm
##
#####################################################################

## REFERENCE {"vsphere_network":{"type": "vsphere_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "vsphere" {
  allow_unverified_ssl = "true"
}

data "vsphere_virtual_machine" "virtual_machine_template" {
  name          = "${var.virtual_machine_template_name}"
  datacenter_id = "${data.vsphere_datacenter.virtual_machine_datacenter.id}"
}

data "vsphere_virtual_machine" "virtual_machine_template_ubuntu" {
  name          = "${var.virtual_machine_template_ubuntu_name}"
  datacenter_id = "${data.vsphere_datacenter.virtual_machine_datacenter.id}"
}

data "vsphere_datacenter" "virtual_machine_datacenter" {
  name = "${var.virtual_machine_datacenter_name}"
}

data "vsphere_datastore" "virtual_machine_datastore" {
  name          = "${var.virtual_machine_datastore_name}"
  datacenter_id = "${data.vsphere_datacenter.virtual_machine_datacenter.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network_network_name}"
  datacenter_id = "${data.vsphere_datacenter.virtual_machine_datacenter.id}"
}

resource "vsphere_virtual_machine" "db-server" {
  name          = "${var.db-server-name}-${random_pet.vm_id.id}"
  datastore_id  = "${data.vsphere_datastore.virtual_machine_datastore.id}"
  num_cpus      = "${var.virtual_machine_number_of_vcpu}"
  memory        = "${var.virtual_machine_memory}"
  guest_id = "${data.vsphere_virtual_machine.virtual_machine_template.guest_id}"
  resource_pool_id = "${var.virtual_machine_resource_pool}"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.virtual_machine_template.id}"
    customize {
        linux_options {
           host_name = "${var.db-server-name}-${random_pet.vm_id.id}"
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
  disk {
    label = "${var.virtual_machine_disk_name}"
    size = "${var.virtual_machine_disk_size}"
  }
}

resource "vsphere_virtual_machine" "web-server" {
  name          = "${var.web-server-name}-${random_pet.vm_id.id}"
  datastore_id  = "${data.vsphere_datastore.virtual_machine_datastore.id}"
  num_cpus      = "${var.virtual_machine_number_of_vcpu}"
  memory        = "${var.virtual_machine_memory}"
  guest_id = "${data.vsphere_virtual_machine.virtual_machine_template_ubuntu.guest_id}"
  resource_pool_id = "${var.virtual_machine_resource_pool}"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.virtual_machine_template_ubuntu.id}"
    customize {
        linux_options {
           host_name = "${var.web-server-name}-${random_pet.vm_id.id}"
           domain    = "rtp.raleigh.ibm.com"
        }
        network_interface {
                  ipv4_address = "9.37.204.252"
                  ipv4_netmask = 24
         }
        dns_server_list = ["9.42.106.2"]
        ipv4_gateway    = "9.37.204.1"
        dns_suffix_list = ["rtp.raleigh.ibm.com","ibm.com"]
     }
  }
  disk {
    label = "${var.virtual_machine_disk_name}"
    size = "${var.virtual_machine_disk_size}"
    thin_provisioned = false
  }
}

# Random string to key names
resource "random_pet" "vm_id" {
}

resource "null_resource" "null_resource" {
  provisioner "remote-exec" {
     inline = [
        "echo hello vmware > /tmp/hello.txt"
      ]
  }
  connection {
    user = "root"
    host = "${vsphere_virtual_machine.db-server.clone.0.customize.0.network_interface.0.ipv4_address}"
    password = "${var.vm_password}"
  }
}
