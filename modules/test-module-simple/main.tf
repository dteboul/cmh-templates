#####################################################################
##
##      Created 5/30/18 by ucdpadmin. for install-java-ubuntu
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

resource "null_resource" "no-op" {
  connection {
    type = "ssh"
    user = "${var.connection_user}"
    private_key = "${var.private_key_pem}"
    host = "${var.connection_host}"
  }
}

