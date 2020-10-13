#####################################################################
##
##      Created 10/25/18 by ucdpadmin. For Cloud cmh-aws for aws-vol-count-test
##
#####################################################################

#variable "mountpoints" {
#  type = "map"
#  default = {
#    "1" = "/dev/sdb"
#    "2" = "/dev/sdc"
#    "3" = "/dev/sdd"
#    "4" = "/dev/sde"
#  }
#}

#variable "mountpoints2" {
#  type        = "map"
#  default     = {
#    mountpoints = "/dev/sdb, /dev/sdc, /dev/sdd, /dev/sde"
#}

variable "inst1_ami" {
  type = "string"
  description = "Generated"
  default = "ami-759bc50a"
}

variable "inst1_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1a"
}

variable "inst1_name" {
  type = "string"
  description = "Generated"
  default = "inst1"
}

variable "aws_key_pair_name" {
  type = "string"
  description = "Generated"
}

variable "volume_name_volume_size" {
  type = "string"
  description = "Generated"
  default = 20
}

variable "volume_count" {
  type = "string"
  description = "Generated"
  default = "3"
}

