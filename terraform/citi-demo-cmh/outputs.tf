#####################################################################
##
##      Created 10/11/18 by slightly_more_obscure_admin. for citi-demo-cmh
##
#####################################################################

output "security_group_this_security_group_description" {
  value = "${module.security_group.this_security_group_description}"
  description = "The description of the security group"
}

output "security_group_this_security_group_name" {
  value = "${module.security_group.this_security_group_name}"
  description = "The name of the security group"
}

output "security_group_this_security_group_owner_id" {
  value = "${module.security_group.this_security_group_owner_id}"
  description = "The owner ID"
}

output "security_group_this_security_group_vpc_id" {
  value = "${module.security_group.this_security_group_vpc_id}"
  description = "The VPC ID"
}

output "security_group_this_security_group_id" {
  value = "${module.security_group.this_security_group_id}"
  description = "The ID of the security group"
}

