#####################################################################
##
##      Created 3/10/18 by ucdpadmin. for test-cam-project
##
#####################################################################

## REFERENCE {"default-vpc":{"type": "aws_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
  version = "~> 1.8"
}

data "aws_subnet" "subnet" {
  vpc_id = "${var.vpc_id}"  # Generated
  availability_zone = "${var.availability_zone}"  # Generated
}

data "aws_security_group" "group_name" {
  name = "${var.group_name}"
  vpc_id = "${var.vpc_id}"  # Generated
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

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "aws-temp-public-key"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "aws_ebs_volume" "web_volume" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.web_volume_volume_size}"
}

resource "aws_ebs_volume" "db_volume" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.db_volume_volume_size}"
}

resource "aws_volume_attachment" "web-server_web_volume_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.web_volume.id}"
  instance_id = "${aws_instance.web-server.id}"
}

resource "aws_volume_attachment" "db-server_db_volume_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.db_volume.id}"
  instance_id = "${aws_instance.db-server.id}"
}

