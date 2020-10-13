#####################################################################
##
##      Created 5/7/18 by ucdpadmin. for bp-demo-1
##
#####################################################################

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

variable "web-server_ami" {
  type = "string"
  description = "Generated"
}

variable "web-server_aws_instance_type" {
  type = "string"
  description = "Generated"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
}

variable "web-server_name" {
  type = "string"
  description = "Generated"
}

variable "db-server_ami" {
  type = "string"
  description = "Generated"
}

variable "db-server_aws_instance_type" {
  type = "string"
  description = "Generated"
}

variable "db-server_name" {
  type = "string"
  description = "Generated"
}

variable "security_group_id" {
  type = "string"
  description = "The associated security groups."
}

