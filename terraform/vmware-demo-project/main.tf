#####################################################################
##
##      Created 5/31/18 by admin. for vmware-demo-project
##
#####################################################################

## REFERENCE {"dvpg":{"type": "vsphere_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.vsphere_server}"

  allow_unverified_ssl = "${var.allow_unverified_ssl}"
  version = "~> 1.2"
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}


data "vsphere_virtual_machine" "test-vm-1_template" {
  name          = "${var.test-vm-1_template_name}"
  datacenter_id = "${data.vsphere_datacenter.test-vm-1_datacenter.id}"
}

data "vsphere_virtual_machine" "vm-2_template" {
  name          = "${var.vm-2_template_name}"
  datacenter_id = "${data.vsphere_datacenter.vm-2_datacenter.id}"
}

data "vsphere_datacenter" "test-vm-1_datacenter" {
  name = "${var.test-vm-1_datacenter_name}"
}

data "vsphere_datacenter" "vm-2_datacenter" {
  name = "${var.vm-2_datacenter_name}"
}

data "vsphere_datastore" "test-vm-1_datastore" {
  name          = "${var.test-vm-1_datastore_name}"
  datacenter_id = "${data.vsphere_datacenter.test-vm-1_datacenter.id}"
}

data "vsphere_datastore" "vm-2_datastore" {
  name          = "${var.vm-2_datastore_name}"
  datacenter_id = "${data.vsphere_datacenter.vm-2_datacenter.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network_network_name}"
  datacenter_id = "${data.vsphere_datacenter.test-vm-1_datacenter.id}"
}

resource "vsphere_virtual_machine" "test-vm-1" {
  name          = "${var.test-vm-1_name}"
  datastore_id  = "${data.vsphere_datastore.test-vm-1_datastore.id}"
  num_cpus      = "${var.test-vm-1_number_of_vcpu}"
  memory        = "${var.test-vm-1_memory}"
  guest_id = "${data.vsphere_virtual_machine.test-vm-1_template.guest_id}"
  resource_pool_id = "${var.test-vm-1_resource_pool}"
  connection {
    user = "TODO"
    private_key = "${var.private_key}"
  }
  provisioner "ucd" {
    agent_name      = "${var.test-vm-1_agent_name}.${random_id.test-vm-1_agent_id.dec}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.test-vm-1_template.id}"
  }
  disk {
    name = "${var.test-vm-1_disk_name}"
    size = "${var.test-vm-1_disk_size}"
  }
  disk {
    attach = true
    label  = "${var.virtual_disk_disk_label}"
    path   = "${vsphere_virtual_disk.virtual_disk.vmdk_path}"
    unit_number = "${var.virtual_disk_unit_number}"
  }
}

resource "vsphere_virtual_machine" "vm-2" {
  name          = "${var.vm-2_name}"
  datastore_id  = "${data.vsphere_datastore.vm-2_datastore.id}"
  num_cpus      = "${var.vm-2_number_of_vcpu}"
  memory        = "${var.vm-2_memory}"
  guest_id = "${data.vsphere_virtual_machine.vm-2_template.guest_id}"
  resource_pool_id = "${var.test-vm-1_resource_pool}"
  connection {
    user = "TODO"
    private_key = "${var.private_key}"
  }
  provisioner "ucd" {
    agent_name      = "${var.vm-2_agent_name}.${random_id.vm-2_agent_id.dec}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.vm-2_template.id}"
  }
  disk {
    name = "${var.vm-2_disk_name}"
    size = "${var.vm-2_disk_size}"
  }
}

resource "vsphere_virtual_disk" "virtual_disk" {
  size          = "${var.virtual_disk_size}"
  vmdk_path     = "${var.virtual_disk_vmdk_path}"
  datacenter    = "${var.virtual_disk_datacenter_name}"
  datastore     = "${var.virtual_disk_datastore_name}"
  type          = "${var.virtual_disk_disk_type}"
}

resource "ucd_component_mapping" "MariaDB" {
  component = "MariaDB"
  description = "MariaDB Component"
  parent_id = "${ucd_agent_mapping.vm-2_agent.id}"
}

resource "ucd_component_mapping" "WebSphere_Liberty_Profile" {
  component = "WebSphere Liberty Profile"
  description = "WebSphere Liberty Profile Component"
  parent_id = "${ucd_agent_mapping.test-vm-1_agent.id}"
}

resource "ucd_component_mapping" "jke_war" {
  component = "jke.war"
  description = "jke.war Component"
  parent_id = "${ucd_agent_mapping.test-vm-1_agent.id}"
}

resource "ucd_component_mapping" "jke_db" {
  component = "jke.db"
  description = "jke.db Component"
  parent_id = "${ucd_agent_mapping.vm-2_agent.id}"
}

resource "random_id" "vm-2_agent_id" {
  byte_length = 8
}

resource "random_id" "test-vm-1_agent_id" {
  byte_length = 8
}

resource "ucd_component_process_request" "MariaDB" {
  component = "MariaDB"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.MariaDB.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "WebSphere_Liberty_Profile" {
  component = "WebSphere Liberty Profile"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.WebSphere_Liberty_Profile.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "jke_war" {
  component = "jke.war"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.jke_war.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "jke_db" {
  component = "jke.db"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.jke_db.id}"
  version = "LATEST"
}

resource "ucd_resource_tree" "resource_tree" {
  base_resource_group_name = "Base Resource for environment ${var.environment_name}"
}

resource "ucd_environment" "environment" {
  name = "${var.environment_name}"
  application = "JKE"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
  component_property {
      component = "MariaDB"
      name = "text"
      value = "string"
      secure = false
  }
  component_property {
      component = "jke.war"
      name = "JKE_DB_HOST"
      value = "localhost"
      secure = false
  }
  component_property {
      component = "jke.db"
      name = "ChadPropEnv"
      value = "default"
      secure = false
  }
}

resource "ucd_agent_mapping" "vm-2_agent" {
  description = "Agent to manage the vm-2 server"
  agent_name = "${var.vm-2_agent_name}.${random_id.vm-2_agent_id.dec}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

resource "ucd_agent_mapping" "test-vm-1_agent" {
  description = "Agent to manage the test-vm-1 server"
  agent_name = "${var.test-vm-1_agent_name}.${random_id.test-vm-1_agent_id.dec}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}