

variable "singlenode_vm_os_user" {
  type        = "string"
  description = "The user name to use while configuring the Single Node."
  default     = "centos"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1a"
}

variable "aws-ami" {
  type = "string"
  description = "Generated"
  default = "ami-b81dbfc5"
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

variable "aws_key_pair_name" {
  type = "string"
  description = "Generated"
  default = "ans-cmh-key"
}

variable "vm_host_count" {
  type = "string"
  description = "Generated"
  default = "1"
}
