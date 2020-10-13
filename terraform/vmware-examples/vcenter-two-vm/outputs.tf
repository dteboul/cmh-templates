#####################################################################
##
##      Created 5/6/19 by admin. For Cloud vra3 for vcenter-single-vm
##
#####################################################################

# RHEL VM public IP address
output "db_ip_address" {
  value = "${vsphere_virtual_machine.db-server.clone.0.customize.0.network_interface.0.ipv4_address}"
}

output "web_ip_address" {
  value = "${vsphere_virtual_machine.web-server.clone.0.customize.0.network_interface.0.ipv4_address}"
}