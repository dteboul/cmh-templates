#####################################################################
##
##      Created 10/26/18 by ucdpadmin. For Cloud cmh-aws for vra-jke-vcenter-inside
##
#####################################################################

output "vra7-web-server-ip" {
#  value = "${vra7_resource.cmh-vcenter-two-node.resource_configuration["web-server.ip_address"]}"
  value = "fooweb"
}

output "vra7-db-server-ip" {
#  value = "${vra7_resource.cmh-vcenter-two-node.resource_configuration["db-server.ip_address"]}"
  value = "foodb"
}
