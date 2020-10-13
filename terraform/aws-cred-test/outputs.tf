#####################################################################
##
##      Created 1/11/19 by slightly_more_obscure_admin. for aws-cred-test
##
#####################################################################

output "subnet_id" {
  value = "${data.aws_subnet.subnet.id}"
}

