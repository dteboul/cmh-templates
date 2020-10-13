#####################################################################
##
##      Created 8/23/18 by ucdpadmin. for cmh-test-tf-aws-1
##
#####################################################################

## REFERENCE {"aws_network":{"type": "aws_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
#  access_key = "${var.aws_access_id}"
#  secret_key = "${var.aws_secret_key}"
#  region = "${var.region}"
  version = "~> 1.8"
}


data "aws_subnet" "subnet" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
}

resource "aws_instance" "cmh-instance-1" {
  ami = "${var.cmh-instance-1_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.cmh-instance-1_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  tags {
    Name = "${var.cmh-instance-1_name}"
  }
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "${var.aws_key_pair_name}"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}