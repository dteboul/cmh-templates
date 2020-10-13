#####################################################################
##
##      Created 9/13/18 by ucdpadmin. For Cloud cmh-aws-cloud for simple-ucd-test
##
#####################################################################

variable "aws_instance_ami" {
  type = "string"
  description = "Generated"
  default = "ami-06c4cb11"
}

variable "aws_instance_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "m1.small"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1a"
}

variable "aws_instance_name" {
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

variable "aws_instance_agent_name" {
  type = "string"
  description = "Agent name"
}

variable "aws_instance1_ami" {
  type = "string"
  description = "Generated"
}

variable "aws_instance1_aws_instance_type" {
  type = "string"
  description = "Generated"
}

variable "aws_instance1_name" {
  type = "string"
  description = "Generated"
}

