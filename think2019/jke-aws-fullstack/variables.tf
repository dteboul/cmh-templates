#####################################################################
##
##      Created 2/11/19 by ucdpadmin. For Cloud cmh-aws for jke-aws-fullstack
##
#####################################################################

variable "web-server_ami" {
  type = "string"
  description = "Generated"
  default = "ami-759bc50a"
}

variable "web-server_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1a"
}

variable "web-server_name" {
  type = "string"
  description = "Generated"
  default = "jke-aws-web"
}

variable "aws_key_pair_name" {
  type = "string"
  description = "Generated"
  default = "jke-aws-key"
}

variable "db-server_ami" {
  type = "string"
  description = "Generated"
  default = "ami-b81dbfc5"
}

variable "db-server_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "db-server_name" {
  type = "string"
  description = "Generated"
  default = "jke-aws-db"
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
  description = "UCD user"
  default = "admin"
}

variable "ucd_password" {
  type = "string"
  description = "UCD password"
  default = "ec11ipse"
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD server URL"
  default = "http://icdemo3.cloudy-demos.com:9080"
}

variable "environment_name" {
  type = "string"
  description = "Environment name"
  default = "jke-aws-fullstack-env"
}

variable "web-server_agent_name" {
  type = "string"
  description = "Agent name"
  default = "jke-aws-web-agent"
}

variable "db-server_agent_name" {
  type = "string"
  description = "Agent name"
  default = "jke-aws-db-agent"
}
