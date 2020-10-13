#####################################################################
##
##      Created 1/11/19 by slightly_more_obscure_admin. for create-vpc-stack
##
#####################################################################

variable "network_name_prefix" {
  description = "The prefix of names for VPC, Gateway, Subnet and Security Group"
  default     = "citi-vpc"
}
