#####################################################################
##
##      Created 2/1/19 by ucdpadmin. For Cloud cmh-vra for vra-vmware-jke
##
#####################################################################

variable "vra_username" {
  type = "string"
  description = "Generated"
  default = "configurationadmin"
}

variable "vra_password" {
  type = "string"
  description = "Generated"
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

variable "vra_insecure" {
  type = "string"
  description = "Generated"
  default = "true"
}

variable "cmh_vcenter_two_node_2_timeout" {
  type = "string"
  description = "Generated"
  default = "10"
}

variable "web-server_user" {
  type = "string"
  description = "Generated"
  default = "root"
}

variable "web-server_password" {
  type = "string"
  description = "Generated"
}

variable "db-server_user" {
  type = "string"
  description = "Generated"
  default = "root"
}

variable "db-server_password" {
  type = "string"
  description = "Generated"
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
  default = "vra-jke-cmh"
}

variable "web-server_agent_name" {
  type = "string"
  description = "Agent name"
  default = "vra-jke-cmh-web-agent"
}

variable "db-server_agent_name" {
  type = "string"
  description = "Agent name"
  default = "vra-jke-cmh-db-agent"
}

