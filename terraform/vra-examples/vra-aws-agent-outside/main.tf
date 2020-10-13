#####################################################################
##
##      Created 1/24/19 by ucdpadmin. For Cloud cmh-azure for vra-aws-agent-outside
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

resource "vra7_resource" "aws_two_node_cmh" {
  count = 1
  wait_timeout = "${var.aws_two_node_cmh_timeout}"
  catalog_name = "aws-two-node-cmh"
  resource_configuration {
    web-server-ubuntu.myprop = "defaultvalue"
    db-server-centos.ip_address = "" 
    web-server-ubuntu.ip_address = "" 
  }    
}

resource "null_resource" "db-server-centos_0" {
  provisioner "ucd" {
    agent_name      = "${var.db-server-centos_0_agent_name}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.db-server-centos_0_agent_name} -X DELETE
EOT
}
  provisioner "remote-exec" {
     inline = [
        "echo 'hello vra' > /tmp/hello.txt"
      ]
  }
  connection {
    type = "ssh"
    user = "centos"
    private_key = "${file("/tmp/ucdev-aws-nva.pem")}"
    host = "${vra7_resource.aws_two_node_cmh.resource_configuration.db-server-centos.ip_address}"
  }   
}

resource "null_resource" "web-server-ubuntu_1" {
  provisioner "ucd" {
    agent_name      = "${var.web-server-ubuntu_1_agent_name}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.web-server-ubuntu_1_agent_name} -X DELETE
EOT
}
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("/tmp/ucdev-aws-nva.pem")}"
    host = "${vra7_resource.aws_two_node_cmh.resource_configuration.web-server-ubuntu.ip_address}"
  }
}

