#####################################################################
##
##      Created 6/4/18 by ucdpadmin. for install-liberty-linux
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

resource "null_resource" "install-liberty" {
  connection {
    user = "${var.connection_user}"
    host = "${var.connection_host}"
    private_key = "${var.private_key_pem}"
  }
  provisioner "file" {
    source      = "${path.module}/files/wlp-developers-runtime-8.5.5.3.jar"
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
echo "---Installing java---" | tee -a $LOGFILE 2>&1
apt-get update                         >> $LOGFILE 2>&1 || { echo "---Failed to update apt-get system---" | tee -a $LOGFILE; exit 1; }
apt-get install openjdk-8-jdk -y      >> $LOGFILE 2>&1 || { echo "---Failed to install java---" | tee -a $LOGFILE; exit 1; }
echo "---Installing liberty---" | tee -a $LOGFILE 2>&1
rm -rf /opt/was/liberty
java -jar /tmp/wlp-developers-runtime-8.5.5.3.jar --acceptLicense /opt/was/liberty    >> $LOGFILE 2>&1 || { echo "---Failed to install liberty---" | tee -a $LOGFILE; exit 1; }
echo "---Done---" | tee -a $LOGFILE 2>&1
EOT
  }
  provisioner "remote-exec" {
     inline = [
        "chmod +x /tmp/install_liberty.sh; sudo bash /tmp/install_liberty.sh"
      ]
  }

}