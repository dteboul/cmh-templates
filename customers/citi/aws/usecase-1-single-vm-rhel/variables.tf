#####################################################################
##
##      Created 1/9/19 by slightly_more_obscure_admin. for usecase-1-single-vm-rhel
##
#####################################################################

variable "citi-rhel-vm_ami" {
  type = "string"
  description = "RHEL 7.6 AMI"
}

variable "citi-rhel-vm_aws_instance_type" {
  type = "string"
  description = "type"
}

variable "citi-rhel-vm_name" {
  type = "string"
  description = "VM name"
}

variable "aws_key_pair_name" {
  type = "string"
  description = "AWS keypair name"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
}

variable "vpc_id" {
  type = "string"
  description = "Generated"
}

variable "security_group_name" {
  type = "string"
  description = "Generated"
}

variable "volume_size" {
  type = "string"
  description = "Generated"
}

variable "volume_count" {
  type = "string"
  description = "Generated"
}

