#####################################################################
##
##      Created 10/26/18 by ucdpadmin. For Cloud cmh-aws for vra-jke-vcenter-inside
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
  insecure = true
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}

locals {
  full-db-agent-name = "${var.db-vm-1_agent_name}.${random_id.db-vm-1_agent_id.dec}"
  full-web-agent-name = "${var.web-vm-1_agent_name}.${random_id.web-vm-1_agent_id.dec}"
}

resource "vra7_resource" "cmh-vcenter-two-node" {
  count            = 1
  catalog_name = "cmh-vcenter-two-node"
  wait_timeout = "${var.wait_timeout}"
  resource_configuration {
     web-server.ip_address = ""
     db-server.ip_address = ""
     web-agent._agent_name_ = "${local.full-web-agent-name}"
     web-agent._ucd_user_ = "${var.ucd_user}"
     web-agent._ucd_password_ = "${var.ucd_password}"
     web-agent._ucd_server_url_ = "${var.ucd_server_url}" 
     db-agent._agent_name_ = "${local.full-db-agent-name}"
     db-agent._ucd_user_ = "${var.ucd_user}"
     db-agent._ucd_password_ = "${var.ucd_password}"
     db-agent._ucd_server_url_ = "${var.ucd_server_url}"
  }
}


resource "null_resource" "db-vm-1" {
  # Agent inside, do not include UCD provisioner
  depends_on = [ "vra7_resource.cmh-vcenter-two-node" ]

  provisioner "remote-exec" {
     inline = [
        "echo 'hello vra' > /tmp/hello.txt"
      ]
  }

  connection {
    user = "root"
    password = "VRApassw0rd"
    host = "${vra7_resource.cmh-vcenter-two-node.resource_configuration.db-server.ip_address}"
  }
}

resource "null_resource" "web-vm-1" {
  # Agent inside, do not include UCD provisioner
  depends_on = [ "vra7_resource.cmh-vcenter-two-node" ]

  provisioner "remote-exec" {
     inline = [
        "echo 'hello vra' > /tmp/hello.txt"
      ]
  }
  connection {
    user = "root"
    password = "VRApassw0rd"
    host = "${vra7_resource.cmh-vcenter-two-node.resource_configuration.db-server.ip_address}"
  }
}

resource "ucd_component_mapping" "MySQL_Server" {
  component = "MySQL Server"
  description = "MySQL Server Component"
  parent_id = "${ucd_agent_mapping.db-vm-1_agent.id}"
}

resource "ucd_component_mapping" "WebSphere_Liberty_Profile" {
  component = "WebSphere Liberty Profile"
  description = "WebSphere Liberty Profile Component"
  parent_id = "${ucd_agent_mapping.web-vm-1_agent.id}"
}

resource "ucd_component_mapping" "jke_db" {
  component = "jke.db"
  description = "jke.db Component"
  parent_id = "${ucd_agent_mapping.db-vm-1_agent.id}"
}

resource "ucd_component_mapping" "jke_war" {
  component = "jke.war"
  description = "jke.war Component"
  parent_id = "${ucd_agent_mapping.web-vm-1_agent.id}"
}

resource "random_id" "db-vm-1_agent_id" {
  byte_length = 8
}

resource "random_id" "web-vm-1_agent_id" {
  byte_length = 8
}

resource "ucd_component_process_request" "MySQL_Server" {
  component = "MySQL Server"
  environment = "${ucd_environment.environment.id}"
  process = "deploy_centos7"
  resource = "${ucd_component_mapping.MySQL_Server.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "WebSphere_Liberty_Profile" {
  component = "WebSphere Liberty Profile"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.WebSphere_Liberty_Profile.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "jke_db" {
  depends_on = [ "ucd_component_process_request.WebSphere_Liberty_Profile", "ucd_component_process_request.MySQL_Server" ]
  component = "jke.db"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
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
  name = "${var.environment_name}-${random_id.db-vm-1_agent_id.dec}"
  application = "JKE"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
  component_property {
      component = "MySQL Server"
      name = "test2"
      value = ""
      secure = false
  }
  component_property {
      component = "MySQL Server"
      name = "test"
      value = ""
      secure = false
  }
  component_property {
      component = "WebSphere Liberty Profile"
      name = "testenv"
      value = "testme"
      secure = false
  }
  component_property {
      component = "jke.db"
      name = "ChadPropEnv"
      value = "default"
      secure = false
  }
  component_property {
      component = "jke.war"
      name = "JKE_DB_HOST"
      value = "foodb"
#      value = "${vra7_resource.cmh-vcenter-two-node.resource_configuration["db-server.ip_address"]}"
      secure = false
  }
}

resource "ucd_agent_mapping" "db-vm-1_agent" {
  depends_on = [ "null_resource.db-vm-1" ]
  description = "Agent to manage the db-vm-1 server"
  agent_name = "${local.full-db-agent-name}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

resource "ucd_agent_mapping" "web-vm-1_agent" {
  depends_on = [ "null_resource.web-vm-1" ]
  description = "Agent to manage the web-vm-1 server"
  agent_name = "${local.full-web-agent-name}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

