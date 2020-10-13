#####################################################################
##
##      Created 2/21/18 by ucdpadmin. for aws-jke
##
#####################################################################

variable "jke-web-demo_ami" {
  type = "string"
  description = "Generated"
  default = "ami-06c4cb11"
}

variable "jke-web-demo_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1d"
}

variable "jke-web-demo_name" {
  type = "string"
  description = "Generated"
  default = "jke-web-demo-1"
}

variable "jke-db-demo_ami" {
  type = "string"
  description = "Generated"
  default = "ami-4bf3d731"
}

variable "jke-db-demo_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "jke-db-demo_name" {
  type = "string"
  description = "Generated"
  default = "jke-db-demo-1"
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

variable "web-vol-1_volume_size" {
  type = "string"
  description = "Generated"
  default = "15"
}

variable "db-vol-2_volume_size" {
  type = "string"
  description = "Generated"
  default = "25"
}

variable "environment_name" {
  type = "string"
  description = "Generated"
  default = "jke-aws-demo"
}

variable "jke-web-agent_name" {
  type = "string"
  description = "Generated"
  default = "jke-aws-web-agent"
}

variable "jke-db-agent_name" {
  type = "string"
  description = "Generated"
  default = "jke-aws-db-agent"
}

variable "ucd_user" {
  type = "string"
  description = "UCD User."
  default = "admin"
}

variable "ucd_password" {
  type = "string"
  description = "UCD Password."
  default = "ec11ipse"
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD Server URL."
  default = "http://icdemo3.cloudy-demos.com:9080"
}




