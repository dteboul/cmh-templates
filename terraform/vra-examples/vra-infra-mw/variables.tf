#####################################################################
##
##      Created 2/4/19 by admin. for vra-infra-only
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
}

variable "web-server_user" {
  type = "string"
  description = "Generated"
}

variable "web-server_password" {
  type = "string"
  description = "Generated"
}

variable "db-server_user" {
  type = "string"
  description = "Generated"
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
}

variable "web-server_agent_name" {
  type = "string"
  description = "Agent name"
}

variable "aws_access_id" {
  type = "string"
  description = "Generated"
}

variable "aws_secret_key" {
  type = "string"
  description = "Generated"
}

variable "region" {
  type = "string"
  description = "Generated"
}

variable "aws_instance_ami" {
  type = "string"
  description = "Generated"
}

variable "aws_instance_aws_instance_type" {
  type = "string"
  description = "Generated"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
}

variable "aws_instance_name" {
  type = "string"
  description = "Generated"
}

variable "aws_key_pair_name" {
  type = "string"
  description = "Generated"
}

