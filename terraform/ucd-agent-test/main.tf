#####################################################################
##
##      Created 11/8/18 by ucdpadmin. For Cloud cmh-aws for ucd-agent-test
##
#####################################################################

## REFERENCE {"aws_network":{"type": "aws_reference_network"}}

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


data "aws_subnet" "subnet" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
}

data "aws_security_group" "group_name" {
  name = "${var.group_name}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_instance" "cmh-ucd-agent" {
  ami = "${var.cmh-ucd-agent_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.cmh-ucd-agent_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  connection {
    user = "ubuntu"
    private_key = "${tls_private_key.ssh.private_key_pem}"  # tls_private_key
  }
  provisioner "ucd" {
    agent_name      = "${var.cmh-ucd-agent_name}.${random_id.cmh-ucd-agent_agent_id.dec}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.cmh-ucd-agent_name}.${random_id.cmh-ucd-agent_agent_id.dec} -X DELETE
EOT
}
  tags {
    Name = "${var.cmh-ucd-agent_name}"
  }
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "${var.aws_key_pair_name}"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}


resource "random_id" "cmh-ucd-agent_agent_id" {
  byte_length = 8
}


