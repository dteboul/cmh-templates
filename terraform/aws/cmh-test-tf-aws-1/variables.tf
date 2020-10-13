#####################################################################
##
##      Created 8/23/18 by ucdpadmin. for cmh-test-tf-aws-1
##
#####################################################################

variable "cmh-instance-1_ami" {
  type = "string"
  description = "Generated"
  default = "ami-06c4cb11"
}

variable "cmh-instance-1_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1d"
}

variable "cmh-instance-1_name" {
  type = "string"
  description = "Generated"
}

variable "aws_key_pair_name" {
  type = "string"
  description = "Generated"
}

variable "vpc_id" {
  type = "string"
  description = "Generated"
  default = "vpc-6c51be09"
}

