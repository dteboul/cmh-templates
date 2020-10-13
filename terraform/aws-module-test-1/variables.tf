#####################################################################
##
##      Created 7/12/18 by ucdpadmin. for aws-module-test-1
##
#####################################################################

variable "region" {
  type = "string"
  description = "Generated"
  default = "us-east-1"
}

variable "web-instance_ami" {
  type = "string"
  description = "Generated"
  default = "ami-66506c1c"
}

variable "web-instance_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1a"
}

variable "web-instance_name" {
  type = "string"
  description = "Generated"
  default = "cmh-web-instance"
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
  default = "cmh-module-test-env"
}

variable "web-instance_agent_name" {
  type = "string"
  description = "Agent name"
  default = "cmh-module-test-agent"
}

