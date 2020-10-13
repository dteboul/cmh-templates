#####################################################################
##
##      Created 4/26/18 by ucdpadmin. for aws-single-vm-ucd-agent
##
#####################################################################

## REFERENCE {"aws_network":{"type": "aws_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
}

data "aws_subnet" "subnet" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
}

data "aws_security_group" "group_name" {
  name = "${var.group_name}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_instance" "test-aws-server" {
  ami = "${var.test-aws-server_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.test-aws-server_aws_instance_type}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  tags {
    Name = "${var.test-aws-server_name}"
  }
  # Specify the ssh connection
  connection {
    user = "ubuntu"
    private_key = "${tls_private_key.ssh.private_key_pem}"
    host = "${self.public_ip}"
  }
  provisioner "ucd" {
    agent_name = "${var.my_agent_name}"
    ucd_server_url = "${var.ucd_server_url}"
    ucd_user = "${var.ucd_user}"
    ucd_password = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
      echo Going to delete an agent!
      curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.my_agent_name}  -X DELETE
      echo deleted an agent!
EOT
  }
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "aws-temp-public-key"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}

