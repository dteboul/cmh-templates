#####################################################################
##
##      Created 7/26/19 by admin for cloud vra3. for vra-infra-only-2
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "vra7" {
}


resource "vra7_deployment" "cmh_vcenter_two_node_2" {
  count = "1"
  wait_timeout = "${var.cmh_vcenter_two_node_2_timeout}"
  catalog_item_name = "cmh-vcenter-two-node-2"
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

resource "null_resource" "web-server" {
  provisioner "remote-exec" {
     inline = [
        "echo hello vra > /tmp/hello.txt"
      ]
  }
  connection {
    user = "${var.web-server_user}"
    password = "${var.web-server_password}"
    host = "${vra7_deployment.cmh_vcenter_two_node_2.resource_configuration.web-server.ip_address}"
  }    
}

resource "null_resource" "db-server" {
  connection {
    user = "${var.db-server_user}"
    password = "${var.db-server_password}"
    host = "${vra7_deployment.cmh_vcenter_two_node_2.resource_configuration.db-server.ip_address}"
  }    
}