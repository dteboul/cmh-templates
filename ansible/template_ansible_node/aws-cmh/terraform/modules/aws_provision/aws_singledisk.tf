
provider "aws" {
  version = "~> 1.8"
}

## REFERENCE {"default-vpc":{"type": "aws_reference_network"}}
data "aws_subnet" "subnet" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
}

data "aws_security_group" "group_name" {
  name = "${var.group_name}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_instance" "aws-vm" {
  count = "${var.vm_count}"
  ami = "${var.aws-ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  tags {
    Name = "${var.vm_name}-${count.index}"
  }
}

resource "null_resource" "vm-create_done" {
  depends_on = ["aws_instance.aws-vm"]

  provisioner "local-exec" {
    command = "echo 'VM creates done for ${var.vm_name}X.'"
  }
}

resource "aws_key_pair" "auth" {
    key_name = "${var.aws_key_pair_name}"
    public_key = "${var.public_ssh_key}"
}




