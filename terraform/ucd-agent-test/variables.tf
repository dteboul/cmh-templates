#####################################################################
##
##      Created 11/8/18 by ucdpadmin. For Cloud cmh-aws for ucd-agent-test
##
#####################################################################

variable "cmh-ucd-agent_ami" {
  type = "string"
  description = "Generated"
  default = "ami-759bc50a"
}

variable "cmh-ucd-agent_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1a"
}

variable "cmh-ucd-agent_name" {
  type = "string"
  description = "Generated"
  default = "cmh-test-agent"
}

variable "aws_key_pair_name" {
  type = "string"
  description = "Generated"
}

variable "vpc_id" {
  type = "string"
  description = "Generated"
  default = "vpc-6c51be09"
}

variable "group_name" {
  type = "string"
  description = "Generated"
  default = "ucdev_secgroup_nva"
}

variable "ucd_user" {
  type = "string"
  description = "UCD User."
  default = "admin"
}

variable "ucd_password" {
  type = "string"
  description = "UCD Password"
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD Server URL."
  default = "http://icdemo3.cloudy-demos.com:9080"
}

