#####################################################################
##
##      Created 7/25/18 by admin. for azure-create-demo-1
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "azurerm" {
  version = "~> 1.1"
}


resource "azurerm_virtual_machine" "testvm" {
  name                  = "${var.testvm_name}"
  location              = "${var.vm_location}"
  vm_size               = "${var.vm_size}"
  resource_group_name   = "${azurerm_resource_group.test-rg.name}"
  network_interface_ids = [ "${azurerm_network_interface.test-nic-cmh.id}" ]
  delete_data_disks_on_termination = "${var.test-cmh-disk_data_disk_delete}"
  storage_data_disk {
    name            = "${azurerm_managed_disk.test-cmh-disk.name}"
    managed_disk_id = "${azurerm_managed_disk.test-cmh-disk.id}"
    create_option   = "${var.test-cmh-disk_data_disk_create_option}"
    lun             = "${var.test-cmh-disk_data_disk_lun}"
    disk_size_gb    = "${azurerm_managed_disk.test-cmh-disk.disk_size_gb}"
  }
  tags {
    Name = "${var.testvm_name}"
  }
  os_profile {
    computer_name  = "${var.testvm_os_profile_name}"
    admin_username = "${var.testvm_azure_user}"
    admin_password = "${var.testvm_azure_user_password}"
  }
  storage_image_reference {
    publisher = "${var.testvm_publisher}"
    offer     = "${var.testvm_offer}"
    sku       = "${var.testvm_sku}"
    version   = "${var.testvm_version}"
  }
  os_profile_linux_config {
    disable_password_authentication = "${var.testvm_disable_password_authentication}"
  }
  storage_os_disk {
    name              = "${var.testvm_os_disk_name}"
    caching           = "${var.testvm_os_disk_caching}"
    create_option     = "${var.testvm_os_disk_create_option}"
    managed_disk_type = "${var.testvm_os_disk_managed_disk_type}"
  }
  delete_os_disk_on_termination = "${var.testvm_os_disk_delete}"
}

resource "azurerm_resource_group" "test-rg" {
  name     = "test-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "test-vnet" {
  name                = "test-vnet"
  address_space       = ["${var.azurerm_network_address_space}"]
  location            = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.test-rg.name}"
}

resource "azurerm_network_interface" "test-nic-cmh" {
  name                = "test-nic-cmh"
  location            = "${var.vm_location}"
  resource_group_name   = "${azurerm_resource_group.test-rg.name}"
  network_security_group_id = "${azurerm_network_security_group.security_group.id}"
  ip_configuration {
    name                          = "${var.config}"
    private_ip_address_allocation = "Dynamic"
    subnet_id  = "${azurerm_subnet.test-subnet.id}"
  }
}

resource "azurerm_subnet" "test-subnet" {
  name                 = "test-subnet"
  virtual_network_name = "${azurerm_network_interface.test-nic-cmh.name}"
  address_prefix       = "${var.address_prefix}"
  resource_group_name  = "${azurerm_resource_group.test-rg.name}"
}

resource "azurerm_network_security_group" "security_group" {
  name                = "security_group"
  location            = "${var.vm_location}"
  resource_group_name   = "${azurerm_resource_group.test-rg.name}"
  security_rule {
    name                       = "rule1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_managed_disk" "test-cmh-disk" {
  name                 = "${var.test-cmh-disk_name}"
  location             = "${var.test-cmh-disk_data_disk_location}"
  storage_account_type = "${var.test-cmh-disk_data_disk_storage_account_type}"
  create_option        = "${var.test-cmh-disk_data_disk_create_option}"
  disk_size_gb         = "${var.test-cmh-disk_data_disk_size_gb}"
}