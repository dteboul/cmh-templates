#
output "Ansible Public SSH Key for other machines" {
  value = "${tls_private_key.generate.public_key_openssh}"
}

output "vm IP addresses" {
  value = "${module.deployAWSVM_singlenode.vm_public_ip_addresses}"
}
