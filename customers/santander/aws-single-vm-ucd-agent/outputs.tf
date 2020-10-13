#####################################################################
##
##      Created 4/26/18 by ucdpadmin. for aws-single-vm-ucd-agent
##
#####################################################################

# Agent name
# Note: Must use IP address suffix with older agent packages and UCD TF provisioner
output "agent_name" {
  value = "${var.my_agent_name}"
#  value = "${var.my_agent_name}-${aws_instance.test-aws-server.private_ip}"
}