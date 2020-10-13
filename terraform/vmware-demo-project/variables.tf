#####################################################################
##
##      Created 5/31/18 by admin. for vmware-demo-project
##
#####################################################################

variable "user" {
  type = "string"
  description = "Generated"
}

variable "password" {
  type = "string"
  description = "Generated"
}

variable "vsphere_server" {
  type = "string"
  description = "Generated"
}

variable "allow_unverified_ssl" {
  type = "string"
  description = "Generated"
}

variable "test-vm-1_name" {
  type = "string"
  description = "Virtual machine name for test-vm-1"
}

variable "test-vm-1_number_of_vcpu" {
  type = "string"
  description = "Number of virtual cpu's."
}

variable "test-vm-1_memory" {
  type = "string"
  description = "Memory allocation."
}

variable "test-vm-1_disk_name" {
  type = "string"
  description = "The name of the disk. Forces a new disk if changed. This should only be a longer path if attaching an external disk."
}

variable "test-vm-1_disk_size" {
  type = "string"
  description = "The size of the disk, in GiB."
}

variable "test-vm-1_template_name" {
  type = "string"
  description = "Generated"
}

variable "test-vm-1_datacenter_name" {
  type = "string"
  description = "Generated"
}

variable "test-vm-1_datastore_name" {
  type = "string"
  description = "Generated"
}

variable "test-vm-1_resource_pool" {
  type = "string"
  description = "Resource pool."
}

variable "network_network_name" {
  type = "string"
  description = "Generated"
}

variable "vm-2_name" {
  type = "string"
  description = "Virtual machine name for vm-2"
}

variable "vm-2_number_of_vcpu" {
  type = "string"
  description = "Number of virtual cpu's."
}

variable "vm-2_memory" {
  type = "string"
  description = "Memory allocation."
}

variable "vm-2_disk_name" {
  type = "string"
  description = "The name of the disk. Forces a new disk if changed. This should only be a longer path if attaching an external disk."
}

variable "vm-2_disk_size" {
  type = "string"
  description = "The size of the disk, in GiB."
}

variable "vm-2_template_name" {
  type = "string"
  description = "Generated"
}

variable "vm-2_datacenter_name" {
  type = "string"
  description = "Generated"
}

variable "vm-2_datastore_name" {
  type = "string"
  description = "Generated"
}

variable "virtual_disk_size" {
  type = "string"
  description = "Generated"
}

variable "virtual_disk_vmdk_path" {
  type = "string"
  description = "Generated"
}

variable "virtual_disk_datacenter_name" {
  type = "string"
  description = "The name of the datacenter in which to create the disk. Can be omitted when when ESXi or if there is only one datacenter in your infrastructure."
}

variable "virtual_disk_datastore_name" {
  type = "string"
  description = "The name of the datastore in which to create the disk."
}

variable "virtual_disk_disk_type" {
  type = "string"
  description = "The type of disk to create. Can be one of eagerZeroedThick, lazy, or thin. Default: eagerZeroedThick."
  default = "thin"
}

variable "virtual_disk_disk_label" {
  type = "string"
  description = "Generated"
}

variable "virtual_disk_unit_number" {
  type = "string"
  description = "The disk number on the SCSI bus. The maximum value for this setting is the value of scsi_controller_count times 15, minus 1 (so 14, 29, 44, and 59, for 1-4 controllers respectively). The default is 0, for which one disk must be set to. Duplicate unit numbers are not allowed."
}

variable "ucd_user" {
  type = "string"
  description = "UCD User."
  default = "admin"
}

variable "ucd_password" {
  type = "string"
  description = "UCD Password."
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD Server URL."
  default = "http://icdemo3.cloudy-demos.com:9080"
}

variable "private_key" {
  type = "string"
  description = "Generated"
}

variable "environment_name" {
  type = "string"
  description = "Environment name"
}

variable "vm-2_agent_name" {
  type = "string"
  description = "Agent name"
}

variable "test-vm-1_agent_name" {
  type = "string"
  description = "Agent name"
}

