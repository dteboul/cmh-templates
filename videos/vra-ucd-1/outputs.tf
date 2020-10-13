#####################################################################
##
##      Created 2/26/19 by ucdpadmin. For Cloud VRA cloud for vra-ucd-1
##
#####################################################################

output "jke_app_url" {
  value = "http://${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.web-server.ip_address}:9080"
}

output "web_server_ip" {
  value = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.web-server.ip_address}"
}

output "db_server_ip" {
  value = "${vra7_resource.cmh_vcenter_two_node_2.resource_configuration.db-server.ip_address}"
}