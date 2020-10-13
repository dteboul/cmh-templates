#####################################################################
##
##      Created 7/24/18 by admin. for azure-demo-2
##
#####################################################################

## REFERENCE {"azure_network":{"type": "azurerm_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "azurerm" {
  version = "~> 1.1"
}


data "azurerm_subnet" "subnet" {
  name                 = "default"
  virtual_network_name = "${var.vnet-name}"
  resource_group_name   = "${var.group_group_name}"
}

data "azurerm_network_security_group" "security_group" {
  name = "${var.nsg_name}"
  resource_group_name   = "${var.group_group_name}"
}

resource "azurerm_virtual_machine" "test-ubuntu-2" {
  name                  = "${var.test-ubuntu-2_name}"
  location              = "${var.vm_location}"
  vm_size               = "${var.vm_size}"
  resource_group_name   = "${var.group_group_name}"
  network_interface_ids = ["${azurerm_network_interface.interface.id}"]
  tags {
    Name = "${var.test-ubuntu-2_name}"
  }
  os_profile {
    computer_name  = "${var.test-ubuntu-2_os_profile_name}"
    admin_username = "${var.test-ubuntu-2_azure_user}"
    admin_password = "${var.test-ubuntu-2_azure_user_password}"
  }
  storage_image_reference {
    publisher = "${var.test-ubuntu-2_publisher}"
    offer     = "${var.test-ubuntu-2_offer}"
    sku       = "${var.test-ubuntu-2_sku}"
    version   = "${var.test-ubuntu-2_version}"
  }
  os_profile_linux_config {
    disable_password_authentication = "${var.test-ubuntu-2_disable_password_authentication}"
  }
  storage_os_disk {
    name              = "${var.test-ubuntu-2_os_disk_name}"
    caching           = "${var.test-ubuntu-2_os_disk_caching}"
    create_option     = "${var.test-ubuntu-2_os_disk_create_option}"
    managed_disk_type = "${var.test-ubuntu-2_os_disk_managed_disk_type}"
  }
  delete_os_disk_on_termination = "${var.test-ubuntu-2_os_disk_delete}"
}

resource "azurerm_network_interface" "interface" {
  name                = "interface123"
  location            = "${var.vm_location}"
  resource_group_name = "${var.group_group_name}"
  network_security_group_id = "${data.azurerm_network_security_group.security_group.id}"
  ip_configuration {
    name                          = "${var.config}"
    private_ip_address_allocation = "Dynamic"
    subnet_id  = "${data.azurerm_subnet.subnet.id}"
  }
}