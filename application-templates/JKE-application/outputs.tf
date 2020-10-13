#####################################################################
##
##      Created 5/22/18 by ucdpadmin. for JKE-application
##
#####################################################################

output "app_url" {
  value = "http://${var.jke-web-agent_connection_host}:9080"
}