#####################################################################
##
##      Created 2/20/18 by ucdpadmin. for multi-cloud-demo-2
##
#####################################################################

# SoftLayer public and private vlans
## REFERENCE {"softlayer-vlan":{"type": "ibm_reference_network"}}

# Default AWS VPC
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

provider "ibm" {
  softlayer_username = "${var.ibm_sl_username}"
  softlayer_api_key  = "${var.ibm_sl_api_key}"
  version = "~> 0.7"
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}

data "aws_subnet" "subnet" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${var.web-server_availability_zone}"
}

data "aws_security_group" "group_name" {
  name = "${var.group_name}"
  vpc_id = "${var.vpc_id}"
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

# Create a keypair for the new private key in IBM Cloud
resource "ibm_compute_ssh_key" "ibm_cloud_temp_public_key" {
  label   = "jke-ibmkey-temp-demo-${random_pet.env_id.id}"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

# JKE Application Web Server - AWS
resource "aws_instance" "web-server" {
  ami = "${var.web-server_ami}"
  key_name = "${aws_key_pair.aws_temp_public_key.id}"
  instance_type = "${var.web-server_aws_instance_type}"
  availability_zone = "${var.web-server_availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  provisioner "ucd" {
    agent_name      = "${var.web_agent_name}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
      echo Going to delete an agent!
      curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.web_agent_name}.${self.private_ip}  -X DELETE
      echo deleted an agent!
EOT
  }
  tags {
    Name = "${var.web-server_name}"
  }
  connection {
    user = "ubuntu"
    private_key = "${tls_private_key.ssh.private_key_pem}"
    host = "${self.public_ip}"
  }
}

# JKE Application DB Server - SoftLayer
resource "ibm_compute_vm_instance" "db-server" {
  cores       = 1
  memory      = 1024
  domain      = "${var.vm_instance_domain}"
  hostname    = "${var.vm_instance_hostname}"
  datacenter  = "${var.vm_instance_datacenter}"
  ssh_key_ids             = ["${ibm_compute_ssh_key.ibm_cloud_temp_public_key.id}"]
  os_reference_code = "${var.vm_instance_os_reference_code}"
  public_vlan_id       = "${var.softlayer-vlan_public_vlan_id}"
  private_vlan_id       = "${var.softlayer-vlan_private_vlan_id}"
  provisioner "ucd" {
    agent_name      = "${var.db_agent_name}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
      echo Going to delete an agent!
      curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.db_agent_name}.${self.ipv4_address_private}  -X DELETE
      echo deleted an agent!
EOT
  }
  connection {
    user = "root"
    private_key = "${tls_private_key.ssh.private_key_pem}"
    host = "${self.ipv4_address}"
  }
}

resource "ucd_component_mapping" "MySQL_Server" {
  component = "MySQL Server"
  description = "MySQL Server Component"
  parent_id = "${ucd_agent_mapping.db-server_agent.id}"
}

resource "ucd_component_mapping" "jke_db" {
  component = "jke.db"
  description = "jke.db Component"
  parent_id = "${ucd_agent_mapping.db-server_agent.id}"
}

resource "ucd_component_mapping" "WebSphere_Liberty_Profile" {
  component = "WebSphere Liberty Profile"
  description = "WebSphere Liberty Profile Component"
  parent_id = "${ucd_agent_mapping.web-server_agent.id}"
}

resource "ucd_component_mapping" "jke_war" {
  component = "jke.war"
  description = "jke.war Component"
  parent_id = "${ucd_agent_mapping.web-server_agent.id}"
}

resource "ucd_component_process_request" "MySQL_Server" {
  component = "MySQL Server"
  environment = "${ucd_environment.environment.id}"
  process = "deploy_centos7"
  resource = "${ucd_component_mapping.MySQL_Server.id}"
  version = "LATEST"
}

resource "ucd_component_process_request" "jke_db" {
  depends_on = [ "ucd_component_process_request.MySQL_Server", "ucd_component_process_request.WebSphere_Liberty_Profile" ]
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
  depends_on = [ "ucd_component_process_request.jke_db" ]
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
      value = "${ibm_compute_vm_instance.db-server.ipv4_address_private}"  # ibm_compute_vm_instance
      secure = false
  }
  
  
  
}

resource "ucd_agent_mapping" "db-server_agent" {
  description = "Agent to manage the db-server server"
  agent_name = "${var.db_agent_name}.${ibm_compute_vm_instance.db-server.ipv4_address_private}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

resource "ucd_agent_mapping" "web-server_agent" {
  description = "Agent to manage the web-server server"
  agent_name = "${var.web_agent_name}.${aws_instance.web-server.private_ip}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}
