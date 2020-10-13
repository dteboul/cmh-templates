#####################################################################
##
##      Created 9/11/18 by ucdpadmin. For Cloud cmh-aws for azure-ucd-test
##
#####################################################################


variable "cmh-ubuntu-vm_name" {
  type = "string"
  description = "Generated"
  default = "cmh-ubuntu-vm"
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

variable "cmh-ubuntu-vm_os_profile_name" {
  type = "string"
  description = "Specifies the os profile name."
  default = "profilename"
}

variable "cmh-ubuntu-vm_azure_user" {
  type = "string"
  description = "Generated"
  default = "azureadminuser"
}

variable "cmh-ubuntu-vm_azure_user_password" {
  type = "string"
  description = "Generated"
  default = "Us3rpa88!!!!"
}

variable "cmh-ubuntu-vm_publisher" {
  type = "string"
  default = "Canonical"
}

variable "cmh-ubuntu-vm_offer" {
  type = "string"
  default = "UbuntuServer"
}

variable "cmh-ubuntu-vm_sku" {
  type = "string"
  default = "16.04"
}

variable "cmh-ubuntu-vm_version" {
  type = "string"
  default = "latest"
}

variable "cmh-ubuntu-vm_disable_password_authentication" {
  type = "string"
  description = "Specifies whether to disable password authentication"
  default = "false"
}

variable "cmh-ubuntu-vm_os_disk_name" {
  type = "string"
  description = "Specifies the disk name."
  default ="osdiskname"
}

variable "cmh-ubuntu-vm_os_disk_caching" {
  type = "string"
  description = "Specifies the caching requirements. (Ex:ReadWrite)"
  default="ReadWrite"
}

variable "cmh-ubuntu-vm_os_disk_create_option" {
  type = "string"
  description = "Specifies how the virtual machine should be created. Possible values are Attach (managed disks only) and FromImage."
  default = "FromImage"
}

variable "cmh-ubuntu-vm_os_disk_managed_disk_type" {
  type = "string"
  description = "Specifies the type of managed disk to create. Value must be either Standard_LRS or Premium_LRS. Cannot be used when vhd_uri is specified"
  default = "Standard_LRS"
}

variable "cmh-ubuntu-vm_os_disk_delete" {
  type = "string"
  description = "Delete the OS disk automatically when deleting the VM"
  default = true
}

variable "group_group_name" {
  type = "string"
  description = "Resource Group Name"
  default = "cmh-resourcegroup-1"
}

variable "network_interface_name" {
  type = "string"
  description = "Network Interface Name"
  default = "cmh-test-nic"
}

variable "subnet_id" {
  type = "string"
  description = "Generated"
  default = "/subscriptions/d6c936fb-c7c1-4af3-b343-3fa197f0f9dd/resourceGroups/cmh-resourcegroup-1/providers/Microsoft.Network/virtualNetworks/cmh-resourcegroup-1-vnet/subnets/default"
}

