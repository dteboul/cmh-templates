#####################################################################
##
##      Created 6/4/18 by ucdpadmin. for install-liberty-linux
##
#####################################################################


# Connection hostname or IP address
variable "connection_host" {
  type = "string"
  description = "Connection host"
}

# Connection user
variable "connection_user" {
  type = "string"
  description = "Connection username"
  default = "root"
}

variable "password" {
  type = "string"
  description = "Connection password"
}
