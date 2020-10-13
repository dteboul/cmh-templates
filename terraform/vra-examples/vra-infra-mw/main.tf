#####################################################################
##
##      Created 2/4/19 by admin. for vra-infra-only
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "vra7" {
  username = "${var.vra_username}"
  password = "${var.vra_password}"
  tenant = "${var.vra_tenant}"
  host = "${var.vra_host}"
  insecure = "${var.vra_insecure}"
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}

provider "aws" {
  access_key = "${var.aws_access_id}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
  version = "~> 1.8"
}

# VRA Catalog Resource
resource "vra7_deployment" "cmh_vcenter_two_node_2" {
  count = "1"
  wait_timeout = "${var.cmh_vcenter_two_node_2_timeout}"
  catalog_item_name = "cmh-vcenter-two-node-2"
  resource_configuration {
    db-server.memory = "512"
    db-server.cpu = "1"
    db-server.testproperty1 = "testval1"
    web-server.memory = "512"
    web-server.testprop1-web = "webvalue1"
    web-server.cpu = "1"
    web-server.ip_address = ""   # Leave blank auto populated by terraform
    db-server.ip_address = ""   # Leave blank auto populated by terraform
  }    
}

# Null resource for connection to VRA virtual machine "web-server"
resource "null_resource" "web-server" {
  provisioner "remote-exec" {
     inline = [
        "echo 'hello web server on vra' > /tmp/hello.txt"
      ]
  }
  provisioner "file" {
    destination = "/tmp/install_java.sh"
    content     = <<EOT
#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
LOGFILE="/var/log/install_java.log"
echo "---Installing java---" | tee -a $LOGFILE 2>&1
yum install -y java-1.8.0-openjdk-devel      >> $LOGFILE 2>&1 || { echo "---Failed to install java---" | tee -a $LOGFILE; exit 1; }
echo "---Done---" | tee -a $LOGFILE 2>&1
EOT
  }
  provisioner "remote-exec" {
     inline = [
        "chmod +x /tmp/install_java.sh; sudo bash /tmp/install_java.sh"
      ]
  }
  provisioner "file" {
    source      = "files/wlp-developers-runtime-8.5.5.3.jar"
    destination = "/tmp/wlp-developers-runtime-8.5.5.3.jar"
  }
  provisioner "file" {
    destination = "/tmp/install_liberty.sh"
    content     = <<EOT
#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
LOGFILE="/var/log/install_liberty.log"
echo "---Installing liberty---" | tee -a $LOGFILE 2>&1
java -jar /tmp/wlp-developers-runtime-8.5.5.3.jar --acceptLicense /opt/was/liberty    >> $LOGFILE 2>&1 || { echo "---Failed to install liberty---" | tee -a $LOGFILE; exit 1; }
echo "---Done---" | tee -a $LOGFILE 2>&1
EOT
  }
  provisioner "remote-exec" {
     inline = [
        "chmod +x /tmp/install_liberty.sh; sudo bash /tmp/install_liberty.sh"
      ]
  }
  
  provisioner "ucd" {
    agent_name      = "${var.web-server_agent_name}.${random_id.stack.hex}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.web-server_agent_name}.${random_id.stack.hex} -X DELETE
EOT
}
  connection {
    user = "${var.web-server_user}"
    password = "${var.web-server_password}"
    host = "${vra7_deployment.cmh_vcenter_two_node_2.resource_configuration.web-server.ip_address}"
  }    
}

# Null resource for connection to VRA virtual machine "db-server"
resource "null_resource" "db-server" {
  provisioner "remote-exec" {
     inline = [
        "echo 'hello db server on vra' > /tmp.txt"
      ]
  }
  provisioner "file" {
    destination = "/tmp/install_mariadb.sh"
    content     = <<EOT
set -o errexit
set -o nounset
set -o pipefail
LOGFILE="/var/log/install_mariadb.log"
echo "---Installing mariadb---" | tee -a $LOGFILE 2>&1
yum clean all                             >> $LOGFILE 2>&1 || { echo "---Failed to update yum system---" | tee -a $LOGFILE; exit 1; }
yum -y install mariadb-server mariadb     >> $LOGFILE 2>&1 || { echo "---Failed to install mariadb---" | tee -a $LOGFILE; exit 1; }
systemctl enable mariadb                  >> $LOGFILE 2>&1 || { echo "---Failed to enable mariadb---" | tee -a $LOGFILE; exit 1; }
systemctl start mariadb                   >> $LOGFILE 2>&1 || { echo "---Failed to start mariadb---" | tee -a $LOGFILE; exit 1; }
systemctl status mariadb                  >> $LOGFILE 2>&1 || { echo "---Failed to verify status of mariadb---" | tee -a $LOGFILE; exit 1; }
echo "---Done---" | tee -a $LOGFILE 2>&1
EOT
  }
  provisioner "remote-exec" {
     inline = [
        "chmod +x /tmp/install_mariadb.sh; sudo bash /tmp/install_mariadb.sh"
      ]
  }
  connection {
    user = "${var.db-server_user}"
    password = "${var.db-server_password}"
    host = "${vra7_deployment.cmh_vcenter_two_node_2.resource_configuration.db-server.ip_address}"
  }    
}

resource "ucd_component_mapping" "jke_war_web-server" {
  component = "jke.war"
  description = "jke.war Component"
  parent_id = "${ucd_agent_mapping.web-server_agent.id}"
}

resource "random_id" "stack" {
  byte_length = 6
}

resource "ucd_component_process_request" "jke_war_web-server" {
  component = "jke.war"
  environment = "${ucd_environment.environment.id}"
  process = "CHOOSE  #  deploy, property_test, unit_test, unit_test_failure, unit_test_long_running, update, win_unit_test"
  resource = "${ucd_component_mapping.jke_war_web-server.id}"
  version = "LATEST"
}

resource "ucd_resource_tree" "resource_tree" {
  base_resource_group_name = "Base Resource for environment ${var.environment_name}-${random_id.stack.hex}"
}

resource "ucd_environment" "environment" {
  name = "${var.environment_name}-${random_id.stack.hex}"
  application = "JKE"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
  component_property {
      component = "jke.war"
      name = "JKE_DB_HOST"
      value = "${vra7_deployment.cmh_vcenter_two_node_2.resource_configuration.web-server.ip_address}"  # vra7_deployment
      secure = false
  }
  component_property {
      component = "jke.war"
      name = "testenv"
      value = "testval"
      secure = false
  }
}

resource "ucd_agent_mapping" "web-server_agent" {
  depends_on = [ "null_resource.web-server" ]
  description = "Agent to manage the web-server server"
  agent_name = "${var.web-server_agent_name}.${random_id.stack.hex}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}

resource "aws_instance" "aws_instance" {
  ami = "${var.aws_instance_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.aws_instance_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "${var.aws_instance_name}"
  }
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "${var.aws_key_pair_name}"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}