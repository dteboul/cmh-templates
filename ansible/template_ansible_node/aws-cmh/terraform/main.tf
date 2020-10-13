provider "aws" {
  version = "~> 1.8"
}

provider "random" {
  version = "~> 1.0"
}

provider "local" {
  version = "~> 1.1"
}

provider "null" {
  version = "~> 1.0"
}

provider "tls" {
  version = "~> 1.0"
}

resource "random_string" "random-dir" {
  length  = 8
  special = false
}

resource "tls_private_key" "generate" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "null_resource" "create-temp-random-dir" {
  provisioner "local-exec" {
    command = "${format("mkdir -p  /tmp/%s" , "${random_string.random-dir.result}")}"
  }
}

module "deployAWSVM_singlenode" {
  source = "./modules/aws_provision"

  vm_count = "${var.vm_host_count}"
  availability_zone = "${var.availability_zone}"
  aws_key_pair_name = "${var.aws_key_pair_name}"
  aws-ami = "${var.aws-ami}"
  aws_instance_type = "${var.aws_instance_type}"
  vpc_id = "${var.vpc_id}"
  group_name = "${var.group_name}"
  public_ssh_key = "${tls_private_key.generate.public_key_openssh}"
}

module "ansible_install" {
  source               = "./modules/install_ansible"
  private_key          = "${tls_private_key.generate.private_key_pem}"
#  vm_os_password       = "${var.singlenode_vm_os_password}"
  vm_os_user           = "${var.singlenode_vm_os_user}"
#  vm_ipv4_address_list = "${concat(var.singlenode_vm_ipv4_address)}"
  vm_ipv4_address_list = "${concat(module.deployAWSVM_singlenode.vm_public_ip_addresses)}"
  random               = "${random_string.random-dir.result}"
  dependsOn            = "${module.deployAWSVM_singlenode.dependsOn}"
}
