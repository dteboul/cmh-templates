#####################################################################
##
##      Created 5/14/18 by ucdpadmin. for aws-mysql-liberty-two-node
##
#####################################################################

## REFERENCE {"default-vpc":{"type": "aws_reference_network"}}


provider "aws" {
  version = "~> 1.8"
}

data "aws_subnet" "subnet" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
}

data "aws_security_group" "group_name" {
  name = "${var.group_name}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_instance" "db-server" {
  ami = "${var.db-server_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.db-server_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  tags {
    Name = "${var.db-server_name}"
  }
}

resource "aws_instance" "web-server" {
  ami = "${var.web-server_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.web-server_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  tags {
    Name = "${var.web-server_name}"
  }
}

# Random string to key names
resource "random_pet" "env_id" {
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name   = "awskey-demo-${random_pet.env_id.id}"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}


resource "null_resource" "install-java" {
  provisioner "file" {
    destination = "/tmp/install_java.sh"
#    content     = <<EOT
##!/bin/bash
#echo "hello"
#EOT
  }
  provisioner "remote-exec" {
     inline = [
        "chmod +x /tmp/install_java.sh; sudo bash /tmp/install_java.sh"
      ]
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${tls_private_key.ssh.private_key_pem}"  # tls_private_key
    host = "${aws_instance.web-server.public_ip}"  # aws_instance
  }
}

