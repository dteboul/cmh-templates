#####################################################################
##
##      Created 5/30/18 by ucdpadmin. for install-java-ubuntu
##
#####################################################################

# Connection hostname or IP address
variable "connection_host" {
  type = "string"
  description = "Generated"
}

# Private key pem for remote connection
variable "private_key_pem" {
  type = "string"
  description = "Generated"
}

# Connection user
variable "connection_user" {
  type = "string"
  description = "Generated"
  default = "ubuntu"
}

# Used to depend on other modules
variable "dependency" { default = ""}
