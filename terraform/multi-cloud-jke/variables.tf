#####################################################################
##
##      Created 2/16/18 by ucdpadmin. for multi-cloud-jke
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

# IBM Cloud
variable "ibm_bmx_api_key" {
  type = "string"
  description = "Generated"
  default = "None"
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

variable "ibm_sl_datacenter" {
  type = "string"
  description = "Generated"
  default = "dal05"
}

variable "ibm_sl_db_server_hostname" {
  type = "string"
  description = "Generated"
  default = "jke-db-server"
}

variable "ibm_sl_db_server_domain" {
  type = "string"
  description = "Generated"
  default = "bpd.ibm.com"
}

variable "ibm_sl_db_server_oscode" {
  type = "string"
  description = "Generated"
  default = "CENTOS_7_64"
}

variable "private_vlan_id" {
  type = "string"
  description = "Generated"
  default = "1074945"
}

variable "public_vlan_id" {
  type = "string"
  description = "Generated"
  default = "1074943"
}

variable "environment_name" {
  type = "string"
  description = "Generated"
  default = "multi-jke-env-test"
}

variable "web_agent_name" {
  type = "string"
  description = "Generated"
  default = "jke-web-agent"
}

variable "db_agent_name" {
  type = "string"
  description = "Generated"
  default = "jke-db-agent"
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
