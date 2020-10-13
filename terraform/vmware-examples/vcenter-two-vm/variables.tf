#####################################################################
##
##      Created 5/6/19 by admin. For Cloud vra3 for vcenter-single-vm
##
#####################################################################

variable "web-server-name" {
  type = "string"
  description = "Virtual machine name for web-server"
}

variable "db-server-name" {
  type = "string"
  description = "Virtual machine name for db-server"
}

variable "virtual_machine_number_of_vcpu" {
  type = "string"
  description = "Number of virtual cpu's."
}

variable "virtual_machine_memory" {
  type = "string"
  description = "Memory allocation."
}

variable "virtual_machine_disk_name" {
  type = "string"
  description = "The name of the disk. Forces a new disk if changed. This should only be a longer path if attaching an external disk."
}

variable "virtual_machine_disk_size" {
  type = "string"
  description = "The size of the disk, in GiB"
}

variable "virtual_machine_template_name" {
  type = "string"
  description = "Generated"
}

variable "virtual_machine_template_ubuntu_name" {
  type = "string"
  description = "Generated"
}

variable "virtual_machine_datacenter_name" {
  type = "string"
  description = "Generated"
}

variable "virtual_machine_datastore_name" {
  type = "string"
  description = "Generated"
}

variable "virtual_machine_resource_pool" {
  type = "string"
  description = "Resource pool"
}

variable "network_network_name" {
  type = "string"
  description = "Generated"
}

variable "vm_password" {
  type = "string"
  description = "Generated"
  default = "VRApassw0rd"
}

