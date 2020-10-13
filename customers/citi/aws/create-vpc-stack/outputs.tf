#####################################################################
##
##      Created 1/11/19 by slightly_more_obscure_admin. for create-vpc-stack
##
#####################################################################

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "app_security_group_id" {
  value = "${aws_security_group.application.id}"
}

output "app_security_group_name" {
  value = "${aws_security_group.application.name}"
}
