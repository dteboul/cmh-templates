#####################################################################
##
##      Created 5/1/18 by ucdpadmin. for azure-app-service-sample
##
#####################################################################


variable "location" {
  type = "string"
  description = "Generated"
  default = "Central US"
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
  default = "apache1"
}

variable "agent-name" {
  type = "string"
  default = "import"
  description = "Generated"
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

variable "subscription_id" {
  type = "string"
  description = "Generated"
}

variable "client_id" {
  type = "string"
  description = "Generated"
}

variable "client_secret" {
  type = "string"
  description = "Generated"
}

variable "tenant_id" {
  type = "string"
  description = "Generated"
}





