#####################################################################
##
##      Created 6/18/18 by admin.
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

##############################################################
# Install Apache
##############################################################
resource "null_resource" "install_apache_httpd" {
  # Specify the ssh connection

  connection {
    host = "${var.host_ip}"
    type = "ssh"
    user = "${var.cam_user}"
    password = "${var.cam_user_password}"
  }


    
  # Create the installation script
  provisioner "file" {
   content = <<EOF
    
#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
LOGFILE="/var/log/installApache2.log"
HOST_NAME=$1
USER_NAME=$2
HOST_PASSWORD=$3
echo "---my dns hostname is $HOST_NAME---" | tee -a $LOGFILE 2>&1
hostnamectl set-hostname $HOST_NAME                                  >> $LOGFILE 2>&1 || { echo "---Failed to set hostname---" | tee -a $LOGFILE; exit 1; }
#update
echo "---update system---" | tee -a $LOGFILE 2>&1
apt-get update                                                        >> $LOGFILE 2>&1 || { echo "---Failed to update system---" | tee -a $LOGFILE; exit 1; }
echo "---install apache2---" | tee -a $LOGFILE 2>&1
apt-get install -y apache2                                            >> $LOGFILE 2>&1 || { echo "---Failed to install apache2---" | tee -a $LOGFILE; exit 1; }
echo "---set keepalive Off---" | tee -a $LOGFILE 2>&1
sed -i 's/KeepAlive On/KeepAlive Off/' /etc/apache2/apache2.conf      >> $LOGFILE 2>&1 || { echo "---Failed to config apache2---" | tee -a $LOGFILE; exit 1; }
echo "---enable mpm_prefork---" | tee -a $LOGFILE 2>&1
cat << EOT > /etc/apache2/mods-available/mpm_prefork.conf
<IfModule mpm_prefork_module>
        StartServers            4
        MinSpareServers         20
        MaxSpareServers         40
        MaxRequestWorkers       200
        MaxConnectionsPerChild  4500
</IfModule>
EOT
a2dismod mpm_event                                                    >> $LOGFILE 2>&1 || { echo "---Failed to set mpm event---" | tee -a $LOGFILE; exit 1; }
a2enmod mpm_prefork                                                   >> $LOGFILE 2>&1 || { echo "---Failed to set mpm perfork---" | tee -a $LOGFILE; exit 1; }
echo "---restart apache2---" | tee -a $LOGFILE 2>&1
systemctl restart apache2                                             >> $LOGFILE 2>&1 || { echo "---Failed to restart apache2---" | tee -a $LOGFILE; exit 1; }
echo "---setup virtual host---" | tee -a $LOGFILE 2>&1
cat << EOT > /etc/apache2/sites-available/$HOST_NAME.conf
<Directory /var/www/html/$HOST_NAME/public_html>
    Require all granted
</Directory>
<VirtualHost *:80>
        ServerName $HOST_NAME
        ServerAdmin camadmin@localhost
        DocumentRoot /var/www/html/$HOST_NAME/public_html
        ErrorLog /var/www/html/$HOST_NAME/logs/error.log
        CustomLog /var/www/html/$HOST_NAME/logs/access.log combined
</VirtualHost>
EOT
mkdir -p /var/www/html/$HOST_NAME/{public_html,logs}
a2ensite $HOST_NAME                                                  >> $LOGFILE 2>&1 || { echo "---Failed to setup virtual host---" | tee -a $LOGFILE; exit 1; }
echo "---setup helloworld.html---" | tee -a $LOGFILE 2>&1
cat << EOT > /var/www/html/$HOST_NAME/public_html/helloworld.html
<!DOCTYPE html>
<html>
<body>
<h1>Hello world header</h1>
<p>Hello world, my FQDN is $HOST_NAME</p>
</body>
</html>
EOT
echo "---disable default virtual host and restart apache2---" | tee -a $LOGFILE 2>&1
a2dissite 000-default.conf                                            >> $LOGFILE 2>&1 || { echo "---Failed to disable default virtual host---" | tee -a $LOGFILE; exit 1; }
systemctl restart apache2                                             >> $LOGFILE 2>&1 || { echo "---Failed to restart apache2---" | tee -a $LOGFILE; exit 1; }
echo "---installed apache2 successfully---" | tee -a $LOGFILE 2>&1
EOF

    destination = "/tmp/installation.sh"
  }

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installation.sh; sudo bash /tmp/installation.sh \"${var.host_name}\" \"${var.cam_user}\" \"${var.cam_user_password}\"",
    ]
  }
}