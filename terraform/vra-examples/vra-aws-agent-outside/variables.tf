#####################################################################
##
##      Created 1/24/19 by ucdpadmin. For Cloud cmh-azure for vra-aws-agent-outside
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

variable "aws_two_node_cmh_timeout" {
  type = "string"
  description = "Generated"
}

variable "db-server-centos_0_agent_name" {
  type = "string"
  description = "Generated"
}

variable "ucd_server_url" {
  type = "string"
  description = "Generated"
}

variable "ucd_user" {
  type = "string"
  description = "Generated"
}

variable "ucd_password" {
  type = "string"
  description = "Generated"
}

variable "web-server-ubuntu_1_agent_name" {
  type = "string"
  description = "Generated"
}

