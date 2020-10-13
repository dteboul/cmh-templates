#####################################################################
##
##      Created 2/1/19 by ucdpadmin. For Cloud cmh-vra for vra-vmware-jke
##
#####################################################################

output "camtags_tagsmap" {
  value = "${module.camtags.tagsmap}"
}

output "camtags_tagslist" {
  value = "${module.camtags.tagslist}"
}

