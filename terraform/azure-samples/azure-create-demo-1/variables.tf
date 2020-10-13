#####################################################################
##
##      Created 7/25/18 by admin. for azure-create-demo-1
##
#####################################################################

variable "testvm_name" {
  type = "string"
  description = "Generated"
  default = "cmh-test-vm-create"
}

variable "vm_location" {
  type = "string"
  description = "Generated"
}

variable "vm_size" {
  type = "string"
  description = "Generated"
}

variable "testvm_os_profile_name" {
  type = "string"
  description = "Specifies the os profile name."
  default = "profilename"
}

variable "testvm_azure_user" {
  type = "string"
  description = "Generated"
}

variable "testvm_azure_user_password" {
  type = "string"
  description = "Generated"
}

variable "testvm_publisher" {
  type = "string"
  default = "MicrosoftWindowsServer"
}

variable "testvm_offer" {
  type = "string"
  default = "WindowsServer"
}

variable "testvm_sku" {
  type = "string"
  default = "Datacenter"
}

variable "testvm_version" {
  type = "string"
  default = "latest"
}

variable "testvm_disable_password_authentication" {
  type = "string"
  description = "Specifies whether to disable password authentication"
  default = "false"
}

variable "testvm_os_disk_name" {
  type = "string"
  description = "Specifies the disk name."
  default ="osdiskname"
}

variable "testvm_os_disk_caching" {
  type = "string"
  description = "Specifies the caching requirements. (Ex:ReadWrite)"
  default="ReadWrite"
}

variable "testvm_os_disk_create_option" {
  type = "string"
  description = "Specifies how the virtual machine should be created. Possible values are Attach (managed disks only) and FromImage."
}

variable "testvm_os_disk_managed_disk_type" {
  type = "string"
  description = "Specifies the type of managed disk to create. Value must be either Standard_LRS or Premium_LRS. Cannot be used when vhd_uri is specified"
  default = "Standard_LRS"
}

variable "testvm_os_disk_delete" {
  type = "string"
  description = "Delete the OS disk automatically when deleting the VM"
  default = true
}

variable "location" {
  type = "string"
  description = "Generated"
}

variable "azurerm_network_address_space" {
  type = "string"
  description = "Generated"
}

variable "config" {
  type = "string"
  description = "Generated"
}

variable "address_prefix" {
  type = "string"
  description = "Generated"
}

variable "test-cmh-disk_name" {
  type = "string"
  description = "Generated"
}

variable "test-cmh-disk_data_disk_location" {
  type = "string"
  description = "Generated"
}

variable "test-cmh-disk_data_disk_storage_account_type" {
  type = "string"
  description = "Generated"
}

variable "test-cmh-disk_data_disk_create_option" {
  type = "string"
  description = "Other choices are Import, Empty, Copy, FromImage"
  default = "Empty"
}

variable "test-cmh-disk_data_disk_size_gb" {
  type = "string"
  description = "Generated"
}

variable "test-cmh-disk_data_disk_delete" {
  type = "string"
  description = "Delete the data disk automatically when deleting the VM"
  default = "true"
}

variable "test-cmh-disk_data_disk_lun" {
  type = "string"
  description = "Generated"
}

