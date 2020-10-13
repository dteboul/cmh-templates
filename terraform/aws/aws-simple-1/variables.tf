#####################################################################
##
##      Created 2/5/19 by ucdpadmin. For Cloud VRA cloud for aws-simple-1
##
#####################################################################

variable "test-server_ami" {
  type = "string"
  description = "Generated"
  default = "ami-759bc50a"
}

variable "test-server_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.small"
}

variable "availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1a"
}

variable "test-server_name" {
  type = "string"
  description = "Generated"
  default = "demo-testserver"
}

variable "aws_key_pair_name" {
  type = "string"
  description = "Generated"
  default = "demo-testkey"
}

variable "vpc_id" {
  type = "string"
  description = "Generated"
  default = "vpc-6c51be09"
}

variable "test-vol-1_volume_size" {
  type = "string"
  description = "Generated"
  default = "8"
}

variable "group_name" {
  type = "string"
  description = "Generated"
  default = "ucdev_secgroup_nva"
}

variable "ucd_user" {
  type = "string"
  description = "UCD user"
  default = "admin"
}

variable "ucd_password" {
  type = "string"
  description = "UCD password"
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD server URL"
  default = "http://icdemo3.cloudy-demos.com:9080"
}

variable "environment_name" {
  type = "string"
  description = "Environment name"
  default = "demo-testenv"
}

variable "test-server_agent_name" {
  type = "string"
  description = "Agent name"
  default = "demo-testagent"
}

variable "vra_username" {
  type = "string"
  description = "Generated"
  default = "configurationadmin"
}

variable "vra_password" {
  type = "string"
  description = "Generated"
}

variable "vra_tenant" {
  type = "string"
  description = "Generated"
  default = "vsphere.local"
}

variable "vra_host" {
  type = "string"
  description = "Generated"
  default = "https://UCD-VRA3-03.rtp.raleigh.ibm.com"
}

variable "vra_insecure" {
  type = "string"
  description = "Generated"
  default = "true"
}

variable "cmh_vcenter_two_node_2_timeout" {
  type = "string"
  description = "Generated"
}

variable "web-server_user" {
  type = "string"
  description = "Generated"
}

variable "web-server_password" {
  type = "string"
  description = "Generated"
}

variable "db-server_user" {
  type = "string"
  description = "Generated"
}

variable "db-server_password" {
  type = "string"
  description = "Generated"
}

