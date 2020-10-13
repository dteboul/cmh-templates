#####################################################################
##
##      Created 2/21/18 by ucdpadmin. for aws-jke .  hello world
##
#####################################################################

output "db-public_ip" {
  value = "${aws_instance.jke-db-demo.public_ip}"
}

output "web-public_ip" {
  value = "${aws_instance.jke-web-demo.public_ip}"
}

