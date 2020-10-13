#####################################################################
##
##      Created 6/7/18 by admin. for app-demo-1
##
#####################################################################

variable "web-agent_connection_user" {
  type = "string"
  default = "root"
}

variable "web-agent_connection_private_key" {
  type = "string"
  default = "key_value"
}

variable "web-agent_connection_host" {
  type = "string"
}

variable "db-agent_connection_user" {
  type = "string"
  default = "root"
}

variable "db-agent_connection_private_key" {
  type = "string"
  default = "key_value"
}

variable "db-agent_connection_host" {
  type = "string"
}

variable "ucd_user" {
  type = "string"
  description = "UCD User."
  default = "admin"
}

variable "ucd_password" {
  type = "string"
  description = "UCD Password."
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD Server URL."
  default = "http://icdemo3.cloudy-demos.com:9080"
}

variable "environment_name" {
  type = "string"
  description = "Environment name"
}

variable "db-agent_agent_name" {
  type = "string"
  description = "Agent name"
}

variable "web-agent_agent_name" {
  type = "string"
  description = "Agent name"
}

