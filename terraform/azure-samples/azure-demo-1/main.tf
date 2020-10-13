#####################################################################
##
##      Created 7/24/18 by admin. for azure-demo-1
##
#####################################################################

## REFERENCE {"azure_network":{"type": "azurerm_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "azurerm" {
}


data "azurerm_network_security_group" "security_group" {
  name = "cmh-dev-heat-nsg"
  resource_group_name   = "${var.group_group_name}"
}

data "azurerm_subnet" "subnet" {
  name                 = "default"
  virtual_network_name = "cmh-resourcegroup-1-vnet"
  resource_group_name   = "${var.group_group_name}"
}

resource "azurerm_virtual_machine" "test-vm-ubuntu" {
  name                  = "${var.test-vm-ubuntu_name}"
  location              = "${var.vm_location}"
  vm_size               = "${var.vm_size}"
  resource_group_name   = "${var.group_group_name}"
  network_interface_ids = ["${azurerm_network_interface.interface.id}"]
  tags {
    Name = "${var.test-vm-ubuntu_name}"
  }
  os_profile {
    computer_name  = "${var.test-vm-ubuntu_os_profile_name}"
    admin_username = "${var.test-vm-ubuntu_azure_user}"
    admin_password = "${var.test-vm-ubuntu_azure_user_password}"
  }
  storage_image_reference {
    publisher = "${var.test-vm-ubuntu_publisher}"
    offer     = "${var.test-vm-ubuntu_offer}"
    sku       = "${var.test-vm-ubuntu_sku}"
    version   = "${var.test-vm-ubuntu_version}"
  }
  os_profile_linux_config {
    disable_password_authentication = "${var.test-vm-ubuntu_disable_password_authentication}"
  }
  storage_os_disk {
    name              = "${var.test-vm-ubuntu_os_disk_name}"
    caching           = "${var.test-vm-ubuntu_os_disk_caching}"
    create_option     = "${var.test-vm-ubuntu_os_disk_create_option}"
    managed_disk_type = "${var.test-vm-ubuntu_os_disk_managed_disk_type}"
  }
  delete_os_disk_on_termination = "${var.test-vm-ubuntu_os_disk_delete}"
}

resource "azurerm_network_interface" "interface" {
  name                = "interface"
  location            = "${var.vm_location}"
  resource_group_name = "${var.group_group_name}"
  ip_configuration {
    name                          = "${var.config}"
    private_ip_address_allocation = "Dynamic"
    subnet_id  = "${data.azurerm_subnet.subnet.id}"
  }
}
