#####################################################################
##
##      Created 1/11/19 by slightly_more_obscure_admin.
##
#####################################################################

output "tagsmap" {
  value = "${data.external.readtags.result}"
}

output "tagslist" {
  value = "${formatlist("%s${var.separator}%s", keys(data.external.readtags.result), values(data.external.readtags.result))}"
}