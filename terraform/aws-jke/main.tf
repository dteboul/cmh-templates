#####################################################################
##
##      Created 2/21/18 by ucdpadmin. for aws-jke
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
  availability_zone = "${var.availability_zone}"  # Generated
}

data "aws_security_group" "group_name" {
  name = "${var.group_name}"
  vpc_id = "${var.vpc_id}"  # Generated
}

# Create a new SSH key pair to connect to virtual machines
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

# Random string to use for environment and agent names
resource "random_pet" "env_id" {
}

# Create new AWS key pair
resource "aws_key_pair" "aws_temp_public_key" {
  key_name   = "jke-awskey-temp-demo-${random_pet.env_id.id}"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "aws_instance" "jke-web-demo" {
  ami = "${var.jke-web-demo_ami}"
  key_name = "${aws_key_pair.aws_temp_public_key.id}"  # aws_key_pair
  instance_type = "${var.jke-web-demo_aws_instance_type}"
  availability_zone = "${var.availability_zone}"  # Generated
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  connection {
    user = "ubuntu"
    private_key = "${tls_private_key.ssh.private_key_pem}"
    host = "${self.public_ip}"
  }
  provisioner "ucd" {
    agent_name      = "${var.jke-web-agent_name}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  tags {
    Name = "${var.jke-web-demo_name}"
  }
}

resource "aws_instance" "jke-db-demo" {
  ami = "${var.jke-db-demo_ami}"
  key_name = "${aws_key_pair.aws_temp_public_key.id}"  # aws_key_pair
  instance_type = "${var.jke-db-demo_aws_instance_type}"
  availability_zone = "${var.availability_zone}"  # Generated
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  connection {
    user = "ec2-user"
    private_key = "${tls_private_key.ssh.private_key_pem}"
    host = "${self.public_ip}"
  }
  provisioner "ucd" {
    agent_name      = "${var.jke-db-agent_name}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  tags {
    Name = "${var.jke-db-demo_name}"
  }
}

resource "aws_ebs_volume" "web-vol-1" {
  availability_zone = "${var.availability_zone}"  # Generated
  size              = "${var.web-vol-1_volume_size}"
}

resource "aws_ebs_volume" "db-vol-2" {
  availability_zone = "${var.availability_zone}"  # Generated
  size              = "${var.db-vol-2_volume_size}"
}

resource "aws_volume_attachment" "jke-web-demo_web-vol-1_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.web-vol-1.id}"
  instance_id = "${aws_instance.jke-web-demo.id}"
}

resource "aws_volume_attachment" "jke-db-demo_db-vol-2_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.db-vol-2.id}"
  instance_id = "${aws_instance.jke-db-demo.id}"
}

resource "ucd_component_mapping" "MySQL_Server" {
  component = "MySQL Server"
  description = "MySQL Server Component"
  parent_id = "${ucd_agent_mapping.jke-db-demo_agent.id}"
}

resource "ucd_component_mapping" "jke_db" {
  component = "jke.db"
  description = "jke.db Component"
  parent_id = "${ucd_agent_mapping.jke-db-demo_agent.id}"
}

resource "ucd_component_mapping" "WebSphere_Liberty_Profile" {
  component = "WebSphere Liberty Profile"
  description = "WebSphere Liberty Profile Component"
  parent_id = "${ucd_agent_mapping.jke-web-demo_agent.id}"
}

resource "ucd_component_mapping" "jke_war" {
  component = "jke.war"
  description = "jke.war Component"
  parent_id = "${ucd_agent_mapping.jke-web-demo_agent.id}"
}

resource "ucd_component_process_request" "MySQL_Server" {
  component = "MySQL Server"
  environment = "${ucd_environment.environment.id}"
  process = "deploy_centos7"
  resource = "${ucd_component_mapping.MySQL_Server.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "jke_db" {
  component = "jke.db"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.jke_db.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "WebSphere_Liberty_Profile" {
  component = "WebSphere Liberty Profile"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.WebSphere_Liberty_Profile.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "jke_war" {
  component = "jke.war"
  environment = "${ucd_environment.environment.id}"
  process = "deploy"
  resource = "${ucd_component_mapping.jke_war.id}"
  version = "LATEST"
}

resource "ucd_resource_tree" "resource_tree" {
  base_resource_group_name = "Base Resource for environment ${var.environment_name}-${random_pet.env_id.id}"
}

resource "ucd_environment" "environment" {
  name = "${var.environment_name}-${random_pet.env_id.id}"
  application = "JKE"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
  component_property {
      component = "MySQL Server"
      name = "test"
      value = ""
      secure = false
  }
  component_property {
      component = "MySQL Server"
      name = "test2"
      value = ""
      secure = false
  }
  component_property {
      component = "jke.db"
      name = "ChadPropEnv"
      value = "default"
      secure = false
  }
  component_property {
      component = "jke.war"
      name = "JKE_DB_HOST"
      value = "${aws_instance.jke-db-demo.private_ip}"  # aws_instance
      secure = false
  }
}

resource "ucd_agent_mapping" "jke-db-demo_agent" {
  description = "Agent to manage the jke-db-demo server"
  agent_name = "${var.jke-db-agent_name}.${aws_instance.jke-db-demo.private_ip}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

resource "ucd_agent_mapping" "jke-web-demo_agent" {
  description = "Agent to manage the jke-web-demo server"
  agent_name = "${var.jke-web-agent_name}.${aws_instance.jke-web-demo.private_ip}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

