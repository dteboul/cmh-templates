#####################################################################
##
##      Created 2/8/18 by ucdpadmin. for jke-aws
##
#####################################################################

## REFERENCE {"default-vpc":{"type": "reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
  access_key = "${var.aws_access_id}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
  version = "~> 1.8"
}

data "aws_subnet" "subnet" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
}

# TODO - verify if name and vpc_id are both required, or just name
data "aws_security_group" "sec_group" {
  name = "${var.sec_group}"
  vpc_id = "${var.vpc_id}"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "aws_key_pair" "cmh_example_key" {
  key_name   = "cmh_example-key"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "aws_instance" "jke-web" {
  ami = "${var.jke-web_ami}"
#  key_name = "${var.jke-web_key_name}"
  key_name = "${aws_key_pair.cmh_example_key.id}"
  instance_type = "${var.jke-web_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  security_groups = ["${data.aws_security_group.sec_group.id}"]
  connection {
    user = "ubuntu"
    private_key = "${tls_private_key.ssh.private_key_pem}"
  }
  provisioner "ucd" {
    agent_name      = "${var.agent_name}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  tags {
    Name = "${var.jke-web_name}"
  }
}

resource "aws_instance" "jke-db" {
  ami = "${var.jke-db_ami}"
#  key_name = "${var.jke-db_key_name}"
  key_name = "${aws_key_pair.cmh_example_key.id}"
  instance_type = "${var.jke-db_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  security_groups = ["${data.aws_security_group.sec_group.id}"]
  tags {
    Name = "${var.jke-db_name}"
  }
}

resource "aws_ebs_volume" "cmh_volume_name" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.cmh_volume_name_volume_size}"
}

resource "aws_volume_attachment" "jke-web_cmh_volume_name_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.cmh_volume_name.id}"
  instance_id = "${aws_instance.jke-web.id}"
}
