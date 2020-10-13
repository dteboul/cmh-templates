#####################################################################
##
##      Created 5/7/18 by ucdpadmin. for bp-demo-1
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
  access_key = "${var.aws_access_id}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
  version = "~> 1.8"
}


resource "aws_instance" "web-server" {
  ami = "${var.web-server_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.web-server_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  tags {
    Name = "${var.web-server_name}"
  }
}

resource "aws_instance" "db-server" {
  ami = "${var.db-server_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.db-server_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "${var.db-server_name}"
  }
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "aws-temp-public-key"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}