#####################################################################
##
##      Created 4/26/18 by ucdpadmin. for ucd-test-app
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

resource "ucd_component_mapping" "ucd_blueprint_designer_test" {
  component = "ucd_blueprint_designer_test"
  description = "ucd_blueprint_designer_test Component"
  parent_id = "${ucd_agent_mapping.test_agent.id}"
}

resource "ucd_component_process_request" "ucd_blueprint_designer_test" {
  component = "ucd_blueprint_designer_test"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.ucd_blueprint_designer_test.id}"
  version = "LATEST"
}

resource "ucd_resource_tree" "resource_tree" {
  base_resource_group_name = "Base Resource for environment ${var.environment_name}"
}

resource "ucd_environment" "environment" {
  name = "${var.environment_name}"
  application = "ucd_blueprint_designer_test_app"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
}

resource "ucd_agent_mapping" "test_agent" {
#  depends_on = [ "ucd_environment.environment" ]
  description = "Agent to manage the aws_instance server"
  agent_name = "${var.agent_name}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}