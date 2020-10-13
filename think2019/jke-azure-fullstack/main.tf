#####################################################################
##
##      Created 2/11/19 by ucdpadmin. For Cloud VRA cloud for jke-azure-fullstack
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "azurerm" {
  version = "~> 1.1"
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}

resource "azurerm_virtual_machine" "web-server" {
  name                  = "${var.web-server_name}-${random_pet.stack.id}"
  location              = "${var.location}"
  vm_size               = "${var.vm_size}"
  resource_group_name   = "${azurerm_resource_group.group.name}"
  network_interface_ids = ["${azurerm_network_interface.interface.id}"]
  connection {
    user = "${var.web-server_azure_user}"
    password = "${var.web-server_azure_user_password}"
    host = "${azurerm_public_ip.public_ip.ip_address}"
  }
  provisioner "ucd" {
    agent_name      = "${var.web-server_agent_name}.${random_pet.stack.id}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.web-server_agent_name}.${random_pet.stack.id} -X DELETE
EOT
}
  tags {
    Name = "${var.web-server_name}"
  }
  os_profile {
    computer_name  = "web-server-osprofile"
    admin_username = "${var.web-server_azure_user}"
    admin_password = "${var.web-server_azure_user_password}"
  }
  storage_image_reference {
    publisher = "${var.web-server_publisher}"
    offer     = "${var.web-server_offer}"
    sku       = "${var.web-server_sku}"
    version   = "${var.web-server_version}"
  }
  os_profile_linux_config {
    disable_password_authentication = "false"
  }
  storage_os_disk {
    name              = "${var.web-server_os_disk_name}-${random_pet.stack.id}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.web-server_os_disk_managed_disk_type}"
  }
  delete_os_disk_on_termination = "true"
}

resource "azurerm_resource_group" "group" {
  name     = "cmh-group-${random_pet.stack.id}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "azure-vnet" {
  name                = "azure-vnet-${random_pet.stack.id}"
  address_space       = [ "10.0.0.0/16" ]
  location            = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.group.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${random_pet.stack.id}"
  virtual_network_name = "${azurerm_virtual_network.azure-vnet.name}"
  address_prefix = "10.0.2.0/24"
  resource_group_name  = "${azurerm_resource_group.group.name}"
}

resource "azurerm_network_interface" "interface" {
  name                = "web-server-nic-${random_pet.stack.id}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  network_security_group_id = "${azurerm_network_security_group.security_group.id}"
  ip_configuration {
    name                          = "ipConfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id  = "${azurerm_subnet.subnet.id}"
    public_ip_address_id = "${azurerm_public_ip.public_ip.id}"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                         = "web-public_ip-${random_pet.stack.id}"
  location                     = "${var.location}"
  public_ip_address_allocation = "Static"
  resource_group_name   = "${azurerm_resource_group.group.name}"
}

# Random string to key names
resource "random_pet" "stack" {
}

resource "azurerm_network_security_group" "security_group" {
  name                = "security_group"
  location            = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.group.name}"
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

resource "ucd_component_mapping" "ucd_blueprint_designer_test_web-server" {
  component = "ucd_blueprint_designer_test"
  description = "ucd_blueprint_designer_test Component"
  parent_id = "${ucd_agent_mapping.web-server_agent.id}"
}

resource "ucd_component_process_request" "ucd_blueprint_designer_test_web-server" {
  component = "ucd_blueprint_designer_test"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.ucd_blueprint_designer_test_web-server.id}"
  version = "LATEST"
}

resource "ucd_resource_tree" "resource_tree" {
  base_resource_group_name = "Base Resource for environment ${var.environment_name}-${random_pet.stack.id}"
}

resource "ucd_environment" "environment" {
  name = "${var.environment_name}-${random_pet.stack.id}"
  application = "ucd_blueprint_designer_test_app"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
  component_property {
      component = "ucd_blueprint_designer_test"
      name = "test"
      value = ""
      secure = false
  }
}

resource "ucd_agent_mapping" "web-server_agent" {
  depends_on = [ "azurerm_virtual_machine.web-server" ]
  description = "Agent to manage the web-server server"
  agent_name = "${var.web-server_agent_name}.${random_pet.stack.id}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

