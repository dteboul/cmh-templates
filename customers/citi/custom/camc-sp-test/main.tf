#####################################################################
##
##      Created 1/16/19 by ucdpadmin. For Cloud cmh-azure for camc-sp-test
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

resource "camc_scriptpackage" "create_test_resource" {
  program = ["/bin/bash", "${path.module}/scripts/create_ucd_resource.sh", "-h", "${var.ucd_host}", "-u", "${var.ucd_user}", "-n", "${var.resource_name}", "-d", "${var.resource_desc}"]
  program_sensitive = ["-p", "${var.ucd_password}"]
  on_create = true
}

resource "camc_scriptpackage" "delete_test_resource" {
  depends_on = ["camc_scriptpackage.create_test_resource"]
  program = ["/bin/bash", "${path.module}/scripts/delete_ucd_resource.sh", "-h", "${var.ucd_host}", "-u", "${var.ucd_user}", "-i", "${lookup(camc_scriptpackage.create_test_resource.result, "resource_id")}"]
  program_sensitive = ["-p", "${var.ucd_password}"]
  on_delete = true
}
