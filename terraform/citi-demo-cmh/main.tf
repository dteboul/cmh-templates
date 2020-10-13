#####################################################################
##
##      Created 10/11/18 by slightly_more_obscure_admin. for citi-demo-cmh
##
#####################################################################

## REFERENCE {"default-vpc":{"type": "aws_reference_network"}}

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
  vpc_id = "${var.vpc_id}"  # Generated
}

resource "aws_instance" "test-instance" {
  ami = "${var.test-instance_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.test-instance_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = [ "${data.aws_security_group.group_name.id}", "${module.security_group.this_security_group_id}" ]
  provisioner "remote-exec" {
     inline = [
        "echo 'hello world' > /tmp/hello.txt"
      ]
  }
  
  tags {
    Name = "${var.test-instance_name}"
  }
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "${var.aws_key_pair_name}"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "aws_ebs_volume" "volume_name" {
    availability_zone = "${var.availability_zone}"
    size              = "${var.volume_name_volume_size}"
}

resource "aws_volume_attachment" "test-instance_volume_name_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.volume_name.id}"
  instance_id = "${aws_instance.test-instance.id}"
}

module "install_java_liberty_ubuntu" {
  source = "git::https://github.com/chadh1313/cmh-terraform-modules///install-liberty-java-ubuntu"
  connection_host = "${aws_instance.test-instance.public_ip}"  # aws_instance
  private_key_pem = "${tls_private_key.ssh.private_key_pem}"  # tls_private_key
  connection_user  =  "ubuntu"
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "2.0.0"
  name        = "http-sg"
  description = "Security group with HTTP ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id = "${var.vpc_id}"  # Generated

  ingress_cidr_blocks = ["0.0.0.0/0"]
  
  ingress_rules            = ["ssh-tcp", "all-icmp"]
  egress_rules             = [ "all-all" ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 9080
      to_port     = 9080
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

resource "random_id" "test-instance_agent_id" {
  byte_length = 8
}

resource "random_id" "null_resource_agent_id" {
  byte_length = 8
}

resource "null_resource" "null_resource" {
  provisioner "ucd" {
    agent_name      = "${var.null_resource_agent_name}.${random_id.null_resource_agent_id.dec}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.null_resource_agent_name}.${random_id.null_resource_agent_id.dec} -X DELETE
EOT
}
  connection {
    user = "ubuntu"
    private_key = "${tls_private_key.ssh.private_key_pem}"  # tls_private_key
    host = "${aws_instance.test-instance.public_ip}"  # aws_instance
  }
}

resource "ucd_component_mapping" "jke_war" {
  component = "jke.war"
  description = "jke.war Component"
  parent_id = "${ucd_agent_mapping.null_resource_agent.id}"
}

resource "ucd_component_process_request" "jke_war" {
  component = "jke.war"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.jke_war.id}"
  version = "LATEST"
}

resource "ucd_resource_tree" "resource_tree" {
  base_resource_group_name = "Base Resource for environment ${var.environment_name}"
}

resource "ucd_environment" "environment" {
  name = "${var.environment_name}"
  application = "JKE"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
  component_property {
      component = "jke.war"
      name = "JKE_DB_HOST"
      value = "localhost"
      secure = false
  }
}

resource "ucd_agent_mapping" "null_resource_agent" {
  depends_on = [ "null_resource.null_resource" ]
  description = "Agent to manage the null_resource server"
  agent_name = "${var.null_resource_agent_name}.${random_id.null_resource_agent_id.dec}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

