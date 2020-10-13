#####################################################################
##
##      Created 2/25/19 by ucdpadmin. For Cloud VRA cloud for vra-ucd-video
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "vra7" {
  username = "${var.vra_username}"
  password = "${var.vra_password}"
  tenant = "${var.vra_tenant}"
  host = "${var.vra_host}"
  insecure = "${var.vra_insecure}"
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}


resource "vra7_resource" "cmh_vcenter_two_node_2" {
  count = "1"
  wait_timeout = "${var.cmh_vcenter_two_node_2_timeout}"
  catalog_name = "cmh-vcenter-two-node-2"
  resource_configuration {
    db-server.memory = "512"
    db-server.cpu = "1"
    db-server.testproperty1 = "testval1"
    web-server.memory = "512"
    web-server.testprop1-web = "${var.web-server-testprop1-web}"
    web-server.cpu = "1"
    web-server.ip_address = ""   # Leave blank auto populated by terraform
    db-server.ip_address = ""   # Leave blank auto populated by terraform
  }    
}

resource "null_resource" "web-server" {
  provisioner "ucd" {
    agent_name      = "${var.web-server_agent_name}.${random_id.stack.hex}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.web-server_agent_name}.${random_id.stack.hex} -X DELETE
EOT
}
  connection {
    user = "${var.web-server_user}"
    password = "${var.web-server_password}"
    host = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.web-server.ip_address}"
  }    
}

resource "null_resource" "db-server" {
  provisioner "ucd" {
    agent_name      = "${var.db-server_agent_name}.${random_id.stack.hex}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.db-server_agent_name}.${random_id.stack.hex} -X DELETE
EOT
}
  connection {
    user = "${var.db-server_user}"
    password = "${var.db-server_password}"
    host = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.db-server.ip_address}"
  }    
}

resource "ucd_component_mapping" "WebSphere_Liberty_Profile_web-server" {
  component = "WebSphere Liberty Profile"
  description = "WebSphere Liberty Profile Component"
  parent_id = "${ucd_agent_mapping.web-server_agent.id}"
}

resource "ucd_component_mapping" "jke_war_web-server" {
  component = "jke.war"
  description = "jke.war Component"
  parent_id = "${ucd_agent_mapping.web-server_agent.id}"
}

resource "ucd_component_mapping" "MySQL_Server_db-server" {
  component = "MySQL Server"
  description = "MySQL Server Component"
  parent_id = "${ucd_agent_mapping.db-server_agent.id}"
}

resource "ucd_component_mapping" "jke_db_db-server" {
  component = "jke.db"
  description = "jke.db Component"
  parent_id = "${ucd_agent_mapping.db-server_agent.id}"
}

resource "random_id" "stack" {
  byte_length = 6
}

resource "ucd_component_process_request" "WebSphere_Liberty_Profile_web-server" {
  component = "WebSphere Liberty Profile"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.WebSphere_Liberty_Profile_web-server.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "jke_war_web-server" {
  depends_on = [ "ucd_component_process_request.jke_db_db-server" ]
  component = "jke.war"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.jke_war_web-server.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "MySQL_Server_db-server" {
  component = "MySQL Server"
  environment = "${ucd_environment.environment.id}"
  process = "deploy_centos7"
  resource = "${ucd_component_mapping.MySQL_Server_db-server.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "jke_db_db-server" {
  depends_on = [ "ucd_component_process_request.WebSphere_Liberty_Profile_web-server", "ucd_component_process_request.MySQL_Server_db-server" ]
  component = "jke.db"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.jke_db_db-server.id}"
  version = "LATEST"
}

resource "ucd_resource_tree" "resource_tree" {
  base_resource_group_name = "Base Resource for environment ${var.environment_name}-${random_id.stack.hex}"
}

resource "ucd_environment" "environment" {
  name = "${var.environment_name}-${random_id.stack.hex}"
  application = "JKE"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
  component_property {
      component = "WebSphere Liberty Profile"
      name = "testenv"
      value = "testme"
      secure = false
  }
  component_property {
      component = "jke.war"
      name = "JKE_DB_HOST"
      value = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.db-server.ip_address}"  # vra7_resource
      secure = false
  }
  component_property {
      component = "jke.db"
      name = "ChadPropEnv"
      value = "default"
      secure = false
  }
}

resource "ucd_agent_mapping" "web-server_agent" {
  depends_on = [ "null_resource.web-server" ]
  description = "Agent to manage the web-server server"
  agent_name = "${var.web-server_agent_name}.${random_id.stack.hex}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

resource "ucd_agent_mapping" "db-server_agent" {
  depends_on = [ "null_resource.db-server" ]
  description = "Agent to manage the db-server server"
  agent_name = "${var.db-server_agent_name}.${random_id.stack.hex}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}