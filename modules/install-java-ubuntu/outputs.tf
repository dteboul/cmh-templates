#####################################################################
##
##      Created 5/30/18 by ucdpadmin. for install-java-ubuntu
##
#####################################################################

output "java_module_output" {
  value = "${null_resource.install-java.id}"
  description = "Used for dependent modules"
}