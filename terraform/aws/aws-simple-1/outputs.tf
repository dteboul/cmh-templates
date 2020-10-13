#####################################################################
##
##      Created 2/5/19 by ucdpadmin. For Cloud VRA cloud for aws-simple-1
##
#####################################################################

output "public_ip" {
  value = "${aws_instance.test-server.public_ip}"
}

output "random_id" {
  value = "${random_id.stack.id}"
}

