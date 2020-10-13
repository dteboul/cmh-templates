#####################################################################
##
##      Created 7/24/18 by admin. for azure-demo-2
##
#####################################################################

variable "test-ubuntu-2_name" {
  type = "string"
  description = "Generated"
  default = "cmh-vm-2"
}

variable "vm_location" {
  type = "string"
  description = "Generated"
}

variable "vm_size" {
  type = "string"
  description = "Generated"
}

variable "test-ubuntu-2_os_profile_name" {
  type = "string"
  description = "Specifies the os profile name."
  default = "profilename"
}

variable "test-ubuntu-2_azure_user" {
  type = "string"
  description = "Generated"
}

variable "test-ubuntu-2_azure_user_password" {
  type = "string"
  description = "Generated"
}

variable "test-ubuntu-2_publisher" {
  type = "string"
  default = "MicrosoftWindowsServer"
}

variable "test-ubuntu-2_offer" {
  type = "string"
  default = "WindowsServer"
}

variable "test-ubuntu-2_sku" {
  type = "string"
  default = "Datacenter"
}

variable "test-ubuntu-2_version" {
  type = "string"
  default = "latest"
}

variable "test-ubuntu-2_disable_password_authentication" {
  type = "string"
  description = "Specifies whether to disable password authentication"
  default = "false"
}

variable "test-ubuntu-2_os_disk_name" {
  type = "string"
  description = "Specifies the disk name."
  default ="osdiskname"
}

variable "test-ubuntu-2_os_disk_caching" {
  type = "string"
  description = "Specifies the caching requirements. (Ex:ReadWrite)"
  default="ReadWrite"
}

variable "test-ubuntu-2_os_disk_create_option" {
  type = "string"
  description = "Specifies how the virtual machine should be created. Possible values are Attach (managed disks only) and FromImage."
}

variable "test-ubuntu-2_os_disk_managed_disk_type" {
  type = "string"
  description = "Specifies the type of managed disk to create. Value must be either Standard_LRS or Premium_LRS. Cannot be used when vhd_uri is specified"
  default = "Standard_LRS"
}

variable "test-ubuntu-2_os_disk_delete" {
  type = "string"
  description = "Delete the OS disk automatically when deleting the VM"
  default = true
}

variable "group_group_name" {
  type = "string"
  description = "Resource Group Name"
  default = "group"
}

variable "config" {
  type = "string"
  description = "Generated"
}

variable "vnet-name" {
  type = "string"
  description = "Generated"
}

variable "nsg_name" {
  type = "string"
  description = "Generated"
  default = "cmh-dev-heat-nsg"
}

