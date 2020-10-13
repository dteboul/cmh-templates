#####################################################################
##
##      Created 5/30/18 by ucdpadmin. for install-java-ubuntu
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

resource "null_resource" "install-java" {
  provisioner "file" {
    destination = "/tmp/install_java.sh"
    content     = <<EOT
#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
LOGFILE="/var/log/install_java.log"
echo "---Installing java---" | tee -a $LOGFILE 2>&1
apt-get update                         >> $LOGFILE 2>&1 || { echo "---Failed to update apt-get system---" | tee -a $LOGFILE; exit 1; }
apt-get install openjdk-8-jdk -y      >> $LOGFILE 2>&1 || { echo "---Failed to install java---" | tee -a $LOGFILE; exit 1; }
echo "---Done---" | tee -a $LOGFILE 2>&1
EOT
  }
  provisioner "remote-exec" {
     inline = [
        "chmod +x /tmp/install_java.sh; sudo bash /tmp/install_java.sh"
      ]
  }
  connection {
    type = "ssh"
    user = "${var.connection_user}"
    private_key = "${var.private_key_pem}"
    host = "${var.connection_host}"
  }
}