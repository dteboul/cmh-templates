#####################################################################
##
##      Created 4/26/18 by ucdpadmin. for ucd-test-app
##
#####################################################################

variable "ucd_user" {
  type = "string"
  description = "UCD User."
  default = "admin"
}

variable "ucd_password" {
  type = "string"
  description = "UCD Password."
  default = ""
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD Server URL."
  default = "http://icdemo3.cloudy-demos.com:9080"
}

variable "environment_name" {
  type = "string"
  description = "Generated"
}

variable "agent_name" {
  type = "string"
  description = "Generated"
}

