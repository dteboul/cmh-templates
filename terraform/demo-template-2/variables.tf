#####################################################################
##
##      Created 2/26/18 by ucdpadmin. for demo-template-2
#####################################################################

variable "aws_access_id" {
  type = "string"
  description = "Generated"
  default = "AKIAIK7PKHZGBHLGDZ2Q"
}

variable "aws_secret_key" {
  type = "string"
  description = "Generated"
  default = "9BVc+Qy7fUQvNwZlQAwkn52PK77RYiXxQDllQmZF"
}

variable "region" {
  type = "string"
  description = "Generated"
  default = "us-east-1"
}

variable "web-server_ami" {
  type = "string"
  description = "Generated"
  default = "ami-06c4cb11"
}

variable "web-server_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1d"
}

variable "web-server_name" {
  type = "string"
  description = "Generated"
  default = "demo-web-server"
}

variable "db-server_ami" {
  type = "string"
  description = "Generated"
  default = "ami-4bf3d731"
}

variable "db-server_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "db-server_name" {
  type = "string"
  description = "Generated"
  default = "demo-db-server"
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

variable "web-volume_volume_size" {
  type = "string"
  description = "Generated"
  default = "15"
}

variable "db-volume_volume_size" {
  type = "string"
  description = "Generated"
  default = "20"
}







