
##############################################################
# Vsphere data for provider
##############################################################
#Variable : vm_-name
variable "vm_name" {
  type = "string"
  default = "ans-vm-"
}

#########################################################
##### Resource : vm_
#########################################################

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1a"
}

variable "aws_key_pair_name" {
  type = "string"
  description = "Generated"
}

variable "aws-ami" {
  type = "string"
  description = "Generated"
  default = "ami-759bc50a"
}

variable "aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.small"
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

variable "vm_count" {
  type = "string"
  description = "Generated"
}

variable "public_ssh_key" {
  type = "string"
  description = "Generated"
}