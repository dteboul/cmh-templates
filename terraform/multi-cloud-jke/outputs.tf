#####################################################################
##
##      Created 2/16/18 by ucdpadmin. for multi-cloud-jke
##
#####################################################################

# JKE Web Server IP address
output "web_server_ip_address" {
  value = "${aws_instance.web-server.public_ip}"
}

# JKE DB Server IP address
output "db_server_ip_address" {
  value = "${ibm_compute_vm_instance.db-server.ipv4_address}"
}

