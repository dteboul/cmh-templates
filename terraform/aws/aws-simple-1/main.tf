#####################################################################
##
##      Created 2/5/19 by ucdpadmin. For Cloud VRA cloud for aws-simple-1
##
#####################################################################

## REFERENCE {"default-vpc":{"type": "aws_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
  version = "~> 1.8"
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}

provider "vra7" {
  username = "${var.vra_username}"
  password = "${var.vra_password}"
  tenant = "${var.vra_tenant}"
  host = "${var.vra_host}"
  insecure = "${var.vra_insecure}"
}

data "aws_subnet" "subnet" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
}

data "aws_security_group" "group_name" {
  name = "${var.group_name}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_instance" "test-server" {
  ami = "${var.test-server_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.test-server_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  connection {
    user = "ubuntu"
    private_key = "${tls_private_key.ssh.private_key_pem}"  # tls_private_key
  }
  provisioner "ucd" {
    agent_name      = "${var.test-server_agent_name}.${random_id.stack.hex}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.test-server_agent_name}.${random_id.stack.hex} -X DELETE
EOT
}
  tags {
    Name = "${var.test-server_name}"
  }
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "${var.aws_key_pair_name}"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "aws_ebs_volume" "test-vol-1" {
    availability_zone = "${var.availability_zone}"
    size              = "${var.test-vol-1_volume_size}"
}

resource "aws_volume_attachment" "test-server_test-vol-1_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.test-vol-1.id}"
  instance_id = "${aws_instance.test-server.id}"
}

resource "ucd_component_mapping" "ucd_blueprint_designer_test_test-server" {
  component = "ucd_blueprint_designer_test"
  description = "ucd_blueprint_designer_test Component"
  parent_id = "${ucd_agent_mapping.test-server_agent.id}"
}

resource "random_id" "stack" {
  byte_length = 6
}

resource "ucd_component_process_request" "ucd_blueprint_designer_test_test-server" {
  component = "ucd_blueprint_designer_test"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.ucd_blueprint_designer_test_test-server.id}"
  version = "LATEST"
}

resource "ucd_resource_tree" "resource_tree" {
  base_resource_group_name = "Base Resource for environment ${var.environment_name}-${random_id.stack.hex}"
}

resource "ucd_environment" "environment" {
  name = "${var.environment_name}-${random_id.stack.hex}"
  application = "ucd_blueprint_designer_test_app"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
  component_property {
      component = "ucd_blueprint_designer_test"
      name = "test"
      value = ""
      secure = false
  }
}

resource "ucd_agent_mapping" "test-server_agent" {
  depends_on = [ "aws_instance.test-server" ]
  description = "Agent to manage the test-server server"
  agent_name = "${var.test-server_agent_name}.${random_id.stack.hex}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

resource "null_resource" "null_resource" {
}

resource "null_resource" "web-server" {
  connection {
    user = "${var.web-server_user}"
    password = "${var.web-server_password}"
    host = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.web-server.ip_address}"
  }    
}

resource "null_resource" "db-server" {
  connection {
    user = "${var.db-server_user}"
    password = "${var.db-server_password}"
    host = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.db-server.ip_address}"
  }    
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

