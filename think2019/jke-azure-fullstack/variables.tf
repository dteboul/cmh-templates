#####################################################################
##
##      Created 2/11/19 by ucdpadmin. For Cloud VRA cloud for jke-azure-fullstack
##
#####################################################################

variable "web-server_name" {
  type = "string"
  description = "Generated"
  default = "jke-azure-web"
}

variable "vm_size" {
  type = "string"
  description = "Generated"
  default = "Standard_DS1_v2"
}

variable "web-server_azure_user" {
  type = "string"
  description = "Generated"
  default = "chadh"
}

variable "web-server_azure_user_password" {
  type = "string"
  description = "Generated"
  default ="Zaq123456789"
}

variable "web-server_publisher" {
  type = "string"
  default = "Canonical"
}

variable "web-server_offer" {
  type = "string"
  default = "UbuntuServer"
}

variable "web-server_sku" {
  type = "string"
  default = "16.04-LTS"
}

variable "web-server_version" {
  type = "string"
  default = "latest"
}

variable "web-server_os_disk_name" {
  type = "string"
  description = "Specifies the disk name."
  default ="web-server_osdiskname"
}

variable "web-server_os_disk_managed_disk_type" {
  type = "string"
  description = "Specifies the type of managed disk to create. Value must be either Standard_LRS or Premium_LRS. Cannot be used when vhd_uri is specified"
  default = "Standard_LRS"
}

variable "location" {
  type = "string"
  description = "Generated"
  default = "eastus"
}

variable "ucd_user" {
  type = "string"
  description = "UCD user"
  default = "admin"
}

variable "ucd_password" {
  type = "string"
  description = "UCD password"
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD server URL"
  default = "http://icdemo3.cloudy-demos.com:9080"
}

variable "environment_name" {
  type = "string"
  description = "Environment name"
  default = "jke-azure-full"
}

variable "web-server_agent_name" {
  type = "string"
  description = "Agent name"
  default = "jke-azure-web"
}

