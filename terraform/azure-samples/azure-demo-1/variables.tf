#####################################################################
##
##      Created 7/24/18 by admin. for azure-demo-1
##
#####################################################################


variable "test-vm-ubuntu_name" {
  type = "string"
  description = "Generated"
  default = "cmh-vm-test"
}

variable "vm_location" {
  type = "string"
  description = "Generated"
  default = "eastus"
}

variable "vm_size" {
  type = "string"
  description = "Generated"
  default = "Standard_DS1_v2"
}

variable "test-vm-ubuntu_os_profile_name" {
  type = "string"
  description = "Specifies the os profile name."
  default = "profilename"
}

variable "test-vm-ubuntu_azure_user" {
  type = "string"
  description = "Generated"
  default = "chadh"
}

variable "test-vm-ubuntu_azure_user_password" {
  type = "string"
  description = "Generated"
  default ="Zaq123456789"
}

variable "test-vm-ubuntu_publisher" {
  type = "string"
  default = "Canonical"
}

variable "test-vm-ubuntu_offer" {
  type = "string"
  default = "UbuntuServer"
}

variable "test-vm-ubuntu_sku" {
  type = "string"
  default = "16.04-LTS"
}

variable "test-vm-ubuntu_version" {
  type = "string"
  default = "latest"
}

variable "test-vm-ubuntu_disable_password_authentication" {
  type = "string"
  description = "Specifies whether to disable password authentication"
  default = "false"
}

variable "test-vm-ubuntu_os_disk_name" {
  type = "string"
  description = "Specifies the disk name."
  default ="osdiskname"
}

variable "test-vm-ubuntu_os_disk_caching" {
  type = "string"
  description = "Specifies the caching requirements. (Ex:ReadWrite)"
  default="ReadWrite"
}

variable "test-vm-ubuntu_os_disk_create_option" {
  type = "string"
  description = "Specifies how the virtual machine should be created. Possible values are Attach (managed disks only) and FromImage."
  default = "FromImage"
}

variable "test-vm-ubuntu_os_disk_managed_disk_type" {
  type = "string"
  description = "Specifies the type of managed disk to create. Value must be either Standard_LRS or Premium_LRS. Cannot be used when vhd_uri is specified"
  default = "Standard_LRS"
}

variable "test-vm-ubuntu_os_disk_delete" {
  type = "string"
  description = "Delete the OS disk automatically when deleting the VM"
  default = true
}

variable "group_group_name" {
  type = "string"
  description = "Resource Group Name"
  default = "cmh-resourcegroup-1"
}

variable "config" {
  type = "string"
  description = "Generated"
  default = "config"
}




