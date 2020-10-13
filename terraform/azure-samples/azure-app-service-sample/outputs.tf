#####################################################################
##
##      Created 5/1/18 by ucdpadmin. for azure-app-service-sample
##
#####################################################################

output "app_service_name" {
  value = "${azurerm_app_service.test-app-service.name}"
}
output "app_service_password" {
  value = "${lookup(azurerm_app_service.test-app-service.site_credential[0], "password", "none")}"
}
output "app_service_username" {
  value = "${lookup(azurerm_app_service.test-app-service.site_credential[0], "username", "none")}"
}