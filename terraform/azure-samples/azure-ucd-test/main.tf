#####################################################################
##
##      Created 9/11/18 by ucdpadmin. For Cloud cmh-aws for azure-ucd-test
##
#####################################################################

## REFERENCE {"azure_network":{"type": "azurerm_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "azurerm" {
  version = "~> 1.1"
}


resource "azurerm_virtual_machine" "cmh-ubuntu-vm" {
  name                  = "${var.cmh-ubuntu-vm_name}"
  location              = "${var.vm_location}"
  vm_size               = "${var.vm_size}"
  resource_group_name   = "${var.group_group_name}"
  network_interface_ids = ["${azurerm_network_interface.interface.id}"]
  tags {
    Name = "${var.cmh-ubuntu-vm_name}"
  }
  os_profile {
    computer_name  = "${var.cmh-ubuntu-vm_os_profile_name}"
    admin_username = "${var.cmh-ubuntu-vm_azure_user}"
    admin_password = "${var.cmh-ubuntu-vm_azure_user_password}"
  }
  storage_image_reference {
    publisher = "${var.cmh-ubuntu-vm_publisher}"
    offer     = "${var.cmh-ubuntu-vm_offer}"
    sku       = "${var.cmh-ubuntu-vm_sku}"
    version   = "${var.cmh-ubuntu-vm_version}"
  }
  os_profile_linux_config {
    disable_password_authentication = "${var.cmh-ubuntu-vm_disable_password_authentication}"
  }
  storage_os_disk {
    name              = "${var.cmh-ubuntu-vm_os_disk_name}"
    caching           = "${var.cmh-ubuntu-vm_os_disk_caching}"
    create_option     = "${var.cmh-ubuntu-vm_os_disk_create_option}"
    managed_disk_type = "${var.cmh-ubuntu-vm_os_disk_managed_disk_type}"
  }
  delete_os_disk_on_termination = "${var.cmh-ubuntu-vm_os_disk_delete}"
}

resource "azurerm_network_interface" "interface" {
  name                = "${var.network_interface_name}"
  location            = "${var.vm_location}"
  resource_group_name = "${var.group_group_name}"
  ip_configuration {
    name                          = "ipConfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id  = "${var.subnet_id}"
    public_ip_address_id = "${azurerm_public_ip.public_ip.id}"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                         = "public_ip"
  location                     = "${var.vm_location}"
  public_ip_address_allocation = "Dynamic"
  resource_group_name = "${var.group_group_name}"
  tags {
    environment = "Production"
  }
}