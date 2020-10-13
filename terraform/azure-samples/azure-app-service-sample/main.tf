#####################################################################
##
##      Created 5/1/18 by ucdpadmin. for azure-app-service-sample
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}

provider "aws" {
  access_key = "${var.aws_access_id}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
  version = "~> 1.8"
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  version = "~> 1.1"
}

resource "random_id" "service-id" {
  byte_length = 8
}

resource "azurerm_resource_group" "chadh-app-service-group" {
  name     = "cmh-test-app-service-group-${random_id.service-id.hex}"
  location = "${var.location}"  # Generated
}

resource "azurerm_resource_group" "group" {
  name     = "group"
  location = "${var.location}"
}

resource "azurerm_app_service_plan" "chadh-app-service-plan" {
  name                = "chadh-app-service-plan"
  location            = "${azurerm_resource_group.chadh-app-service-group.location}"
  resource_group_name = "${azurerm_resource_group.chadh-app-service-group.name}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

### Create new Azure app service and service plan ###
resource "azurerm_app_service" "test-app-service" {
  name                = "cmh-test-${random_id.service-id.hex}"
  location            = "${azurerm_resource_group.chadh-app-service-group.location}"
  resource_group_name = "${azurerm_resource_group.chadh-app-service-group.name}"
  app_service_plan_id = "${azurerm_app_service_plan.chadh-app-service-plan.id}"

  site_config {
    java_version           = "1.8"
    java_container         = "TOMCAT"
    java_container_version = "8.5"
  }
}


### UCD ###
resource "ucd_component_mapping" "apache_sample" {
  component = "apache-sample"
  description = "apache-sample Component"
  parent_id = "${ucd_agent_mapping.exec-agent.id}"
}

resource "ucd_component_process_request" "apache_sample" {
  component = "apache-sample"
  environment = "${ucd_environment.environment.id}"
  process = "deploy-to-azure-app-service"
  resource = "${ucd_component_mapping.apache_sample.id}"
  version = "LATEST"
}

resource "ucd_resource_tree" "resource_tree" {
  base_resource_group_name = "Optional - ${random_id.service-id.hex}"
}

resource "ucd_environment" "environment" {
  name = "${var.environment_name}-${random_id.service-id.hex}"
  application = "cea28c6b-a499-49ce-95c9-c0dd91e98899"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
  component_property {
      component = "apache-sample"
      name = "azure_webapp_password"
      value = "${lookup(azurerm_app_service.test-app-service.site_credential[0], "password", "none")}"
      secure = true
  }
  component_property {
      component = "apache-sample"
      name = "azure_webapp_username"
      value = "${lookup(azurerm_app_service.test-app-service.site_credential[0], "username", "none")}"
      secure = false
  }
  component_property {
      component = "apache-sample"
      name = "azure_webapp_site_name"
      value = "${azurerm_app_service.test-app-service.name}"
      secure = false
  }
}

resource "ucd_agent_mapping" "exec-agent" {
  description = "Agent to add to new environment"
  "agent_name" = "${var.agent-name}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

resource "aws_instance" "aws_instance" {
  ami = "${var.aws_instance_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.aws_instance_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "${var.aws_instance_name}"
  }
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "aws-temp-public-key"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}

