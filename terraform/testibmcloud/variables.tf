#####################################################################
##
##      Created 10/12/20 by ucdpadmin for cloud ibmcloud. for test-cam-project2
##
#####################################################################

variable "vm_instance_domain" {
  type = "string"
  default = "ibm.com"
  description = "The domain for the computing instance."
}

variable "vm_instance_hostname" {
  type = "string"
  default = "webhost"
  description = "The hostname for the computing instance."
}

variable "vm_instance_datacenter" {
  type = "string"
  default = "par01"
  description = "The datacenter in which you want to provision the instance. NOTE: If dedicated_host_name or dedicated_host_id is provided then the datacenter should be same as the dedicated host datacenter."
}


variable "ibm_ssh_key_name" {
  type = "string"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCryc9ZCQX2BWO8baPAM78rGpviaHAesmnlaENtqbEmEDuY1znPszHVWlbrBsZlpu+HZAIPZQHMQ4RRZ8k+94Tp4KLHwP/YoWRkXFKuQgxDqfwCb80OaJpNZsf1u6zXf0NQhhgdLmBkSwy8YHvh9j1Vl9kDDsKIzmwzrDUAIohcLVIETgKZpIMtGL7vpMsMg5Qg6ddWb5UkRJiQbGWBAupCKPENqGttW5050DkDYPEM5hbLRwiPjOA/EuNYU9G9Nj9pFTgD+J6xQMeLbpYtVtBUZCtuIYUjl2uRlKrYUXwdwum9AtLvRr0HpS75LfBugvjT4E9jkoVQrunJ9cZnhKPP"
  description = "Generated"
}

variable "vm_instance_os_reference_code" {
  type = "string"
  description = "Generated"
  default     = "UBUNTU_16_64"
}

variable "testsecurefield" {
  description = "testsecurefield"
  type = "string"
  default     = "123456789"
}

variable "ibm_network_public_vlan_id" {
  type = "string"
  description = "Generated"
  default = "2894292"
}

variable "ibm_network_private_vlan_id" {
  type = "string"
  description = "Generated"
  default = "2894294"
}

variable "vm_instance1_hostname" {
  type = "string"
  default = "dbhost"
  description = "The hostname for the computing instance."
}

variable "vm_instance1_os_reference_code" {
  type = "string"
  description = "Generated"
  default     = "UBUNTU_16_64"
}