#####################################################################
##
##      Created 2/4/19 by admin. for vra-infra-only
##
#####################################################################

output "vra7-db-server-ip" {
  value = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.db-server.ip_address}"
}

output "vra7-web-server-ip" {
  value = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.web-server.ip_address}"
}

