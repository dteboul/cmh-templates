#####################################################################
##
##      Created 10/11/18 by slightly_more_obscure_admin. for citi-demo-cmh
##
#####################################################################

variable "test-instance_ami" {
  type = "string"
  description = "Generated"
}

variable "test-instance_aws_instance_type" {
  type = "string"
  description = "Generated"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
}

variable "test-instance_name" {
  type = "string"
  description = "Generated"
}

variable "aws_key_pair_name" {
  type = "string"
  description = "Generated"
}

variable "vpc_id" {
  type = "string"
  description = "Generated"
}

variable "group_name" {
  type = "string"
  description = "Generated"
}

variable "volume_name_volume_size" {
  type = "string"
  description = "Generated"
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

variable "null_resource_agent_name" {
  type = "string"
  description = "Agent name"
}

