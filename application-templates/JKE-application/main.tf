#####################################################################
##
##      Created 5/22/18 by ucdpadmin. for JKE-application
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


resource "null_resource" "jke-web-agent" {
  provisioner "ucd" {
    agent_name      = "${var.jke-web-agent_agent_name}.${random_id.jke-web-agent_agent_id.dec}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  connection {
    type = "ssh"
    user = "${var.jke-web-agent_connection_user}"
    private_key = "${base64decode(var.jke-web-agent_connection_private_key)}"
    host = "${var.jke-web-agent_connection_host}"
  }
}

resource "null_resource" "jke-db-agent" {
  provisioner "ucd" {
    agent_name      = "${var.jke-db-agent_agent_name}.${random_id.jke-db-agent_agent_id.dec}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  connection {
    type = "ssh"
    user = "${var.jke-db-agent_connection_user}"
    private_key = "${base64decode(var.jke-db-agent_connection_private_key)}"
    host = "${var.jke-db-agent_connection_host}"
  }
}

resource "ucd_component_mapping" "jke_db" {
  component = "jke.db"
  description = "jke.db Component"
  parent_id = "${ucd_agent_mapping.jke-db-agent_agent.id}"
}

resource "ucd_component_mapping" "jke_war" {
  component = "jke.war"
  description = "jke.war Component"
  parent_id = "${ucd_agent_mapping.jke-web-agent_agent.id}"
}

resource "random_id" "jke-db-agent_agent_id" {
  byte_length = 8
}

resource "random_id" "jke-web-agent_agent_id" {
  byte_length = 8
}

resource "ucd_component_process_request" "jke_db" {
  component = "jke.db"
  environment = "${ucd_environment.environment.id}"
  process = "deploy-mariadb"
  resource = "${ucd_component_mapping.jke_db.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "jke_war" {
  depends_on = [ "ucd_component_process_request.jke_db" ]
  component = "jke.war"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.jke_war.id}"
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
      component = "jke.db"
      name = "ChadPropEnv"
      value = "default"
      secure = false
  }
  component_property {
      component = "jke.war"
      name = "JKE_DB_HOST"
      value = "${var.jke-db-agent_connection_host}"  # Jke Db Agent Connection Host
      secure = false
  }
}

resource "ucd_agent_mapping" "jke-db-agent_agent" {
  depends_on = [ "null_resource.jke-db-agent" ]
  description = "Agent to manage the jke-db-agent server"
  agent_name = "${var.jke-db-agent_agent_name}.${random_id.jke-db-agent_agent_id.dec}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

resource "ucd_agent_mapping" "jke-web-agent_agent" {
  depends_on = [ "null_resource.jke-web-agent" ]
  description = "Agent to manage the jke-web-agent server"
  agent_name = "${var.jke-web-agent_agent_name}.${random_id.jke-web-agent_agent_id.dec}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}