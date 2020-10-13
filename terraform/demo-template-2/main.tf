#####################################################################
##
##      Created 2/26/18 by ucdpadmin. for demo-template-2
##
#####################################################################

## REFERENCE {"default-vpc":{"type": "aws_reference_network"}}

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
  vpc_id = "${var.vpc_id}"  # Generated
  availability_zone = "${var.availability_zone}"  # Generated
}

data "aws_security_group" "group_name" {
  name = "${var.group_name}"
  vpc_id = "${var.vpc_id}"  # Generated
}

# Random string to use for environment and agent names
resource "random_pet" "env_id" {
}
# Create a new SSH key pair to connect to virtual machines
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}
# Create new AWS key pair
resource "aws_key_pair" "aws_temp_public_key" {
  key_name   = "jke-awskey-temp-demo-${random_pet.env_id.id}"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "aws_instance" "web-server" {
  ami = "${var.web-server_ami}"
  key_name = "${aws_key_pair.aws_temp_public_key.id}"  # aws_key_pair
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
  key_name = "${aws_key_pair.aws_temp_public_key.id}"  # aws_key_pair
  instance_type = "${var.db-server_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  tags {
    Name = "${var.db-server_name}"
  }
}

resource "aws_ebs_volume" "web-volume" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.web-volume_volume_size}"
}

resource "aws_ebs_volume" "db-volume" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.db-volume_volume_size}"
}

resource "aws_volume_attachment" "web-server_web-volume_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.web-volume.id}"
  instance_id = "${aws_instance.web-server.id}"
}

resource "aws_volume_attachment" "db-server_db-volume_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.db-volume.id}"
  instance_id = "${aws_instance.db-server.id}"
}