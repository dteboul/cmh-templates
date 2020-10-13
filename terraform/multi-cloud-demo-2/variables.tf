#####################################################################
##
##      Created 2/20/18 by ucdpadmin. for multi-cloud-demo-2
##
#####################################################################

# AWS
variable "aws_access_id" {
  type = "string"
  description = "Generated"
  default = "AKIAIK7PKHZGBHLGDZ2Q"
}

variable "aws_secret_key" {
  type = "string"
  description = "Generated"
  default = "9BVc+Qy7fUQvNwZlQAwkn52PK77RYiXxQDllQmZF"
}

variable "region" {
  type = "string"
  description = "Generated"
  default = "us-east-1"
}

variable "web-server_ami" {
  type = "string"
  description = "Generated"
  default = "ami-06c4cb11"
}

variable "web-server_aws_instance_type" {
  type = "string"
  description = "Generated"
  default = "t2.medium"
}

variable "web-server_availability_zone" {
  type = "string"
  description = "Generated"
  default = "us-east-1d"
}

variable "web-server_name" {
  type = "string"
  description = "Generated"
  default = "jke-web-server"
}

variable "vpc_id" {
  type = "string"
  description = "Generated"
  default = "vpc-6c51be09"
}

variable "group_name" {
  type = "string"
  description = "Generated"
  default = "ucdev_secgroup_nva"
}

variable "ibm_sl_username" {
  type = "string"
  description = "Generated"
  default = "chadh"
}

variable "ibm_sl_api_key" {
  type = "string"
  description = "Generated"
  default = "db11a3ea386666374f73b8dacf98bda7e2a4b84308d4f30f1a71c8da1f1f820b"
}

variable "vm_instance_domain" {
  type = "string"
  description = "The domain for the computing instance."
  default = "bpd.ibm.com"
}

variable "vm_instance_hostname" {
  type = "string"
  description = "The hostname for the computing instance."
  default = "jke-db-server"
}

variable "vm_instance_datacenter" {
  type = "string"
  description = "The datacenter in which you want to provision the instance. NOTE: If dedicated_host_name or dedicated_host_id is provided then the datacenter should be same as the dedicated host datacenter."
  default = "dal05"
}

variable "vm_instance_os_reference_code" {
  type = "string"
  description = "Generated"
  default = "CENTOS_7_64"
}

variable "softlayer-vlan_public_vlan_id" {
  type = "string"
  description = "Generated"
  default = "1074943"
}

variable "softlayer-vlan_private_vlan_id" {
  type = "string"
  description = "Generated"
  default = "1074945"
}

variable "environment_name" {
  type = "string"
  description = "Generated"
  default = "JKE multicloud env"
}

variable "web_agent_name" {
  type = "string"
  description = "Generated"
  default = "jke-web-agent-2"
}

variable "db_agent_name" {
  type = "string"
  description = "Generated"
  default = "jke-db-agent-2"
}

variable "ucd_user" {
  type = "string"
  description = "UCD User."
  default = "admin"
}

variable "ucd_password" {
  type = "string"
  description = "UCD Password."
  default = "ec11ipse"
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD Server URL."
  default = "http://icdemo3.cloudy-demos.com:9080"
}


