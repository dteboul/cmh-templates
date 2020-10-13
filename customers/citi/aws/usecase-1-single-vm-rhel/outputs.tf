#####################################################################
##
##      Created 1/9/19 by slightly_more_obscure_admin. for usecase-1-single-vm-rhel
##
#####################################################################

# RHEL VM public IP address
output "public_ip_address" {
  value = "${aws_instance.citi-rhel-vm.public_ip}"
}

# RHEL VM instance ID
output "instance_id" {
  value = "${aws_instance.citi-rhel-vm.id}"
}
