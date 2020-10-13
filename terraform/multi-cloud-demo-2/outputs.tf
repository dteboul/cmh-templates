#####################################################################
##
##      Created 2/20/18 by ucdpadmin. for multi-cloud-demo-2
##
#####################################################################

# JKE Web Server IP address
output "web_server_ip_address" {
  value = "${aws_instance.web-server.public_ip}"
}