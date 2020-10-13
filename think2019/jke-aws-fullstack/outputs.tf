#####################################################################
##
##      Created 2/11/19 by ucdpadmin. For Cloud cmh-aws for jke-aws-fullstack
##
#####################################################################

output "db-server-public-ip" {
  value = "${aws_instance.db-server.public_ip}"
}

output "web-server-public-ip" {
  value = "${aws_instance.web-server.public_ip}"
}

output "app-server-url" {
  value = "http://${aws_instance.web-server.public_ip}:9080"
}

