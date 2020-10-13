output "dependsOn" { value = "${null_resource.vm-create_done.id}" description="Output Parameter when Module Complete"}

output "vm_public_ip_addresses" {
  value = "${aws_instance.aws-vm.*.public_ip}"
}