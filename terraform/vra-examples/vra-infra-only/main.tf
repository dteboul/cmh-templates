#####################################################################
##
##      Created 2/4/19 by admin. for vra-infra-only
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

# VRA Catalog Resource
resource "vra7_resource" "cmh_vcenter_two_node_2" {
  count = "1"
  wait_timeout = "${var.cmh_vcenter_two_node_2_timeout}"
  catalog_name = "cmh-vcenter-two-node-2"
  resource_configuration {
    db-server.memory = "512"
    db-server.cpu = "1"
    db-server.testproperty1 = "testval1"
    web-server.memory = "512"
    web-server.testprop1-web = "webvalue1"
    web-server.cpu = "1"
    web-server.ip_address = ""   # Leave blank auto populated by terraform
    db-server.ip_address = ""   # Leave blank auto populated by terraform
  }    
}

# Null resource for connection to VRA virtual machine "web-server"
resource "null_resource" "web-server" {
  provisioner "remote-exec" {
     inline = [
        "echo 'hello web server on vra' > /tmp/hello.txt"
      ]
  }
  connection {
    user = "${var.web-server_user}"
    password = "${var.web-server_password}"
    host = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.web-server.ip_address}"
  }    
}

# Null resource for connection to VRA virtual machine "db-server"
resource "null_resource" "db-server" {
  provisioner "remote-exec" {
     inline = [
        "echo 'hello db server on vra' > /tmp.txt"
      ]
  }
  connection {
    user = "${var.db-server_user}"
    password = "${var.db-server_password}"
    host = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.db-server.ip_address}"
  }    
}