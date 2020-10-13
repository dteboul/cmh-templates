#####################################################################
##
##      Created 10/19/18 by ucdpadmin. For Cloud cmh-aws for vra-jke-aws
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "vra7" {
  username = "configurationadmin"
  password = "VRAconfigadmin74!"
  tenant = "vsphere.local"
  host = "https://UCD-VRA3-03.rtp.raleigh.ibm.com"
  insecure = true
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}

resource "vra7_resource" "aws-two-node-cmh" {
  count            = 1
  catalog_name = "aws-two-node-cmh"
  resource_configuration {
     web-server-ubuntu.ip_address = ""
     db-server-centos.ip_address = ""
  }
}

resource "null_resource" "web-server" {
  provisioner "ucd" {
    agent_name      = "${var.web-server_agent_name}.${random_id.web-server_agent_id.dec}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.web-server_agent_name}.${random_id.web-server_agent_id.dec} -X DELETE
EOT
}
  connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("/tmp/ucdev-aws-nva.pem")}"
      host = "${vra7_resource.aws-two-node-cmh.resource_configuration.web-server-ubuntu.ip_address}"
  }
}

resource "null_resource" "db-server" {
  provisioner "ucd" {
    agent_name      = "${var.db-server_agent_name}.${random_id.db-server_agent_id.dec}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.db-server_agent_name}.${random_id.db-server_agent_id.dec} -X DELETE
EOT
}
  connection {
      type = "ssh"
      user = "centos"
      private_key = "${file("/tmp/ucdev-aws-nva.pem")}"
      host = "${vra7_resource.aws-two-node-cmh.resource_configuration.db-server-centos.ip_address}"
  }
}

resource "ucd_component_mapping" "MySQL_Server" {
  component = "MySQL Server"
  description = "MySQL Server Component"
  parent_id = "${ucd_agent_mapping.db-server_agent.id}"
}

resource "ucd_component_mapping" "jke_db" {
  component = "jke.db"
  description = "jke.db Component"
  parent_id = "${ucd_agent_mapping.db-server_agent.id}"
}

resource "ucd_component_mapping" "WebSphere_Liberty_Profile" {
  component = "WebSphere Liberty Profile"
  description = "WebSphere Liberty Profile Component"
  parent_id = "${ucd_agent_mapping.web-server_agent.id}"
}

resource "ucd_component_mapping" "jke_war" {
  component = "jke.war"
  description = "jke.war Component"
  parent_id = "${ucd_agent_mapping.web-server_agent.id}"
}

resource "random_id" "db-server_agent_id" {
  byte_length = 8
}

resource "random_id" "web-server_agent_id" {
  byte_length = 8
}

resource "ucd_component_process_request" "MySQL_Server" {
  component = "MySQL Server"
  environment = "${ucd_environment.environment.id}"
  process = "deploy_centos7"
  resource = "${ucd_component_mapping.MySQL_Server.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "jke_db" {
  depends_on = [ "ucd_component_process_request.MySQL_Server", "ucd_component_process_request.WebSphere_Liberty_Profile" ]
  component = "jke.db"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.jke_db.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "WebSphere_Liberty_Profile" {
  component = "WebSphere Liberty Profile"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.WebSphere_Liberty_Profile.id}"
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
      component = "jke.db"
      name = "ChadPropEnv"
      value = "default"
      secure = false
  }
  component_property {
      component = "WebSphere Liberty Profile"
      name = "testenv"
      value = "testme"
      secure = false
  }
  component_property {
      component = "jke.war"
      name = "JKE_DB_HOST"
      value = "${vra7_resource.aws-two-node-cmh.resource_configuration.db-server-centos.ip_address}"  # vra7_resource
      secure = false
  }
}

resource "ucd_agent_mapping" "db-server_agent" {
  depends_on = [ "null_resource.db-server" ]
  description = "Agent to manage the db-server server"
  agent_name = "${var.db-server_agent_name}.${random_id.db-server_agent_id.dec}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

resource "ucd_agent_mapping" "web-server_agent" {
  depends_on = [ "null_resource.web-server" ]
  description = "Agent to manage the web-server server"
  agent_name = "${var.web-server_agent_name}.${random_id.web-server_agent_id.dec}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}