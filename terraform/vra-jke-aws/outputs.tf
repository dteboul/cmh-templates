#####################################################################
##
##      Created 10/19/18 by ucdpadmin. For Cloud cmh-aws for vra-jke-aws
##
#####################################################################

output "vra7-db-server-ip" {
  value = "${vra7_resource.aws-two-node-cmh.resource_configuration.db-server-centos.ip_address}"
}


output "vra7-web-server-ip" {
  value = "${vra7_resource.aws-two-node-cmh.resource_configuration.web-server-ubuntu.ip_address}"
}