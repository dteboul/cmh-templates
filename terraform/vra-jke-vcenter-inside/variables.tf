#####################################################################
##
##      Created 10/26/18 by ucdpadmin. For Cloud cmh-aws for vra-jke-vcenter-inside
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
  default = "ec11ipse"
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD Server URL."
  default = "http://icdemo3.cloudy-demos.com:9080"
}

variable "vra_username" {
  type = "string"
  description = "Generated"
  default = "configurationadmin"
}

variable "vra_password" {
  type = "string"
  description = "Generated"
  default = "VRAconfigadmin74!"
}

variable "vra_tenant" {
  type = "string"
  description = "Generated"
  default = "vsphere.local"
}

variable "vra_host" {
  type = "string"
  description = "Generated"
  default = "https://UCD-VRA3-03.rtp.raleigh.ibm.com"
}

variable "environment_name" {
  type = "string"
  description = "Environment name"
  default = "vra-test-env-cmh"
}

variable "db-vm-1_agent_name" {
  type = "string"
  description = "Agent name"
  default = "vra-db-agent-cmh"
}

variable "web-vm-1_agent_name" {
  type = "string"
  description = "Agent name"
  default = "vra-web-agent-cmh"
}

variable "wait_timeout" {
  type = "string"
  description = "Generated"
  default = "30"
}

