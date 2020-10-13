#####################################################################
##
##      Created 2/1/19 by ucdpadmin. For Cloud cmh-vra for vra-infra-vmware
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