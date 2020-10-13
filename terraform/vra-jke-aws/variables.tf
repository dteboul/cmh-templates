#####################################################################
##
##      Created 10/19/18 by ucdpadmin. For Cloud cmh-aws for vra-jke-aws
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
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD Server URL."
  default = "http://icdemo3.cloudy-demos.com:9080"
}

variable "environment_name" {
  type = "string"
  description = "Environment name"
  default = "vra-jke-env"
}

variable "db-server_agent_name" {
  type = "string"
  description = "Agent name"
  default = "vra-db-agent"
}

variable "web-server_agent_name" {
  type = "string"
  description = "Agent name"
  default = "vra-web-agent"
}

