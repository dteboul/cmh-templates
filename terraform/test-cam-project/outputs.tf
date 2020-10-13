#####################################################################
##
##      Created 3/10/18 by ucdpadmin. for test-cam-project
##
#####################################################################

output "web_server_ip_address" {
  value = "${aws_instance.web-server.public_ip}"
}
output "db_server_ip_address" {
  value = "${aws_instance.db-server.public_ip}"
}