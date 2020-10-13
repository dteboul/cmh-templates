#####################################################################
##
##      Created 7/26/19 by admin for cloud vra3. for vra-infra-only-2
##
#####################################################################

output "vra7_web_server_ip_address" {
  value = "${vra7_deployment.cmh_vcenter_two_node_2.resource_configuration.web-server.ip_address}"
}

output "vra7_db_server_ip_address" {
  value = "${vra7_deployment.cmh_vcenter_two_node_2.resource_configuration.db-server.ip_address}"
}
