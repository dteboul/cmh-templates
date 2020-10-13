#####################################################################
##
##      Created 7/12/18 by ucdpadmin. for aws-module-test-1
##
#####################################################################

## REFERENCE {"aws_network":{"type": "aws_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
  region = "${var.region}"
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}

data "aws_db_instance" "jke-db-rds" {
  db_instance_identifier = "jke-mysql-db"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "1.37.0"

  name = "cmh-module-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "2.0.0"
  name        = "http-sg"
  description = "Security group with HTTP ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id = "${module.vpc.vpc_id}"

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

resource "aws_instance" "web-instance" {
  ami = "${var.web-instance_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.web-instance_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id = "${module.vpc.public_subnets[0]}"
  vpc_security_group_ids = [ "${module.security_group.this_security_group_id}" ]
  connection {
    user = "ubuntu"
    private_key = "${tls_private_key.ssh.private_key_pem}"  # tls_private_key
  }
  provisioner "ucd" {
    agent_name      = "${var.web-instance_agent_name}.${random_id.web-instance_agent_id.dec}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.web-instance_agent_name}.${random_id.web-instance_agent_id.dec} -X DELETE
EOT
}
  tags {
    Name = "${var.web-instance_name}"
  }
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "cmh1-key"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "ucd_component_mapping" "jke_war" {
  component = "jke.war"
  description = "jke.war Component"
  parent_id = "${ucd_agent_mapping.web-instance_agent.id}"
}

resource "random_id" "web-instance_agent_id" {
  byte_length = 8
}

resource "ucd_component_process_request" "jke_war" {
  depends_on = [ "module.Install_Liberty" ]
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
      # RDS endpoint returns URL with port for some reason - strip it out
#      value = "${element(split(":","${data.aws_db_instance.jke-db-rds.endpoint}"), 0) }"
      value = "${data.aws_db_instance.jke-db-rds.address}"
      secure = false
  }
}

resource "ucd_agent_mapping" "web-instance_agent" {
  depends_on = [ "aws_instance.web-instance" ]
  description = "Agent to manage the web-instance server"
  agent_name = "${var.web-instance_agent_name}.${random_id.web-instance_agent_id.dec}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

module "Install_Liberty" {
  source = "git::https://github.com/chadh1313/cmh-terraform-modules?ref=master//install-liberty-java-ubuntu"
  connection_host = "${aws_instance.web-instance.public_ip}"  # aws_instance
  private_key_pem = "${tls_private_key.ssh.private_key_pem}"  # tls_private_key
  connection_user  =  "ubuntu"
}

#module "WebSphere_Liberty___ubuntu" {
#  source = "git::https://github.ibm.com/pattern-sdk/cmh-templates//modules/install-liberty-java-ubuntu"
#  connection_host = "${aws_instance.web-instance.public_ip}"  # aws_instance
#  private_key_pem = "${tls_private_key.ssh.private_key_pem}"  # tls_private_key
#  connection_user  =  "ubuntu"
#}
