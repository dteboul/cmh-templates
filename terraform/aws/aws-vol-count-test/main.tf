#####################################################################
##
##      Created 10/25/18 by ucdpadmin. For Cloud cmh-aws for aws-vol-count-test
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
  version = "~> 1.8"
}


resource "aws_instance" "inst1" {
  ami = "${var.inst1_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.inst1_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "${var.inst1_name}"
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
  key_name = "${var.aws_key_pair_name}"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "aws_ebs_volume" "volumes" {
  count = "${var.volume_count}"
  availability_zone = "${var.availability_zone}"
  size              = "${var.volume_name_volume_size}"
}

resource "aws_volume_attachment" "inst1_volume_name_volume_attachment" {
  count = "${var.volume_count}"
  device_name = "${element(split(",", "/dev/sdh,/dev/sdj,/dev/sdk,/dev/sdl"), count.index)}"
  volume_id = "${element(aws_ebs_volume.volumes.*.id, count.index)}"
  instance_id = "${aws_instance.inst1.id}"  # aws_instance
}